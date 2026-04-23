package com.huacai.snack.service.impl;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Offline evaluation for the recommendation strategy using the real MySQL data.
 * <p>
 * Run with:
 * mvn -Dtest=RecommendationOfflineEvaluationTest
 *   -Ddb.host=localhost -Ddb.port=3306 -Ddb.name=huacai-snack
 *   -Ddb.user=root -Ddb.password=123456 test
 */
class RecommendationOfflineEvaluationTest {

    @Test
    void evaluateRecommendationMetrics() throws Exception {
        String host = System.getProperty("db.host", "localhost");
        String port = System.getProperty("db.port", "3306");
        String database = System.getProperty("db.name", "huacai-snack");
        String user = System.getProperty("db.user", "root");
        String password = System.getProperty("db.password", "");

        String jdbcUrl = String.format(
                "jdbc:mysql://%s:%s/%s?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%%2B8&useSSL=false",
                host, port, database);

        try (Connection connection = DriverManager.getConnection(jdbcUrl, user, password)) {
            List<OrderRow> allRows = loadOrderRows(connection);
            List<String> allProducts = loadAllProducts(connection);

            EvaluationResult advanced = evaluate(allRows, allProducts, 10, Strategy.ADVANCED);
            EvaluationResult popular = evaluate(allRows, allProducts, 10, Strategy.POPULAR_ONLY);

            System.out.println("==== Recommendation Offline Evaluation ====");
            System.out.printf("Distinct ordering users: %d%n", advanced.distinctOrderingUsers);
            System.out.printf("Evaluated users (>=2 orders): %d%n", advanced.evaluatedUsers);
            System.out.println("Split rule: leave the last order of each user as the test set.");
            System.out.printf("Advanced strategy HitRate@10 = %.4f%n", advanced.hitRateAtK);
            System.out.printf("Advanced strategy Precision@10 = %.4f%n", advanced.precisionAtK);
            System.out.printf("Popular-only HitRate@10 = %.4f%n", popular.hitRateAtK);
            System.out.printf("Popular-only Precision@10 = %.4f%n", popular.precisionAtK);
            System.out.println();
            System.out.println("-- Per-user details (advanced) --");
            advanced.perUserLines.forEach(System.out::println);
            System.out.println();
            System.out.println("-- Per-user details (popular-only) --");
            popular.perUserLines.forEach(System.out::println);
        }
    }

    private EvaluationResult evaluate(List<OrderRow> allRows,
                                      List<String> allProducts,
                                      int k,
                                      Strategy strategy) {
        Map<Long, List<OrderEvent>> ordersByUser = allRows.stream()
                .collect(Collectors.groupingBy(
                        OrderRow::userId,
                        LinkedHashMap::new,
                        Collectors.collectingAndThen(Collectors.toList(), this::toOrderEvents)
                ));
        Map<Long, OrderEvent> heldOutByUser = new LinkedHashMap<>();
        List<OrderEvent> globalTrainingOrders = new ArrayList<>();
        for (Map.Entry<Long, List<OrderEvent>> entry : ordersByUser.entrySet()) {
            List<OrderEvent> userOrders = entry.getValue();
            if (userOrders.size() < 2) {
                globalTrainingOrders.addAll(userOrders);
                continue;
            }

            for (int i = 0; i < userOrders.size() - 1; i++) {
                globalTrainingOrders.add(userOrders.get(i));
            }
            heldOutByUser.put(entry.getKey(), userOrders.get(userOrders.size() - 1));
        }

        int distinctOrderingUsers = ordersByUser.size();
        int evaluatedUsers = 0;
        int hitUsers = 0;
        double precisionSum = 0D;
        List<String> perUserLines = new ArrayList<>();

        for (Map.Entry<Long, List<OrderEvent>> entry : ordersByUser.entrySet()) {
            Long userId = entry.getKey();
            List<OrderEvent> userOrders = entry.getValue();
            if (userOrders.size() < 2) {
                continue;
            }

            evaluatedUsers++;
            OrderEvent testOrder = heldOutByUser.get(userId);
            Set<String> testItems = new LinkedHashSet<>(testOrder.items.keySet());

            List<String> recommendations = switch (strategy) {
                case ADVANCED -> advancedRecommendations(userId, globalTrainingOrders, allProducts, k);
                case POPULAR_ONLY -> popularRecommendations(globalTrainingOrders, allProducts, userId, k);
            };

            Set<String> hits = recommendations.stream()
                    .filter(testItems::contains)
                    .collect(Collectors.toCollection(LinkedHashSet::new));

            if (!hits.isEmpty()) {
                hitUsers++;
            }
            precisionSum += (double) hits.size() / k;
            perUserLines.add(String.format(
                    "user=%d, testItems=%s, recommendations=%s, hits=%s",
                    userId, testItems, recommendations, hits
            ));
        }

        double denominator = evaluatedUsers == 0 ? 1D : evaluatedUsers;
        return new EvaluationResult(
                distinctOrderingUsers,
                evaluatedUsers,
                hitUsers / denominator,
                precisionSum / denominator,
                perUserLines
        );
    }

    private List<OrderEvent> toOrderEvents(List<OrderRow> rows) {
        Map<String, OrderEvent> grouped = new LinkedHashMap<>();
        rows.stream()
                .sorted(Comparator
                        .comparing(OrderRow::createTime)
                        .thenComparing(OrderRow::orderId))
                .forEach(row -> grouped.computeIfAbsent(
                                row.orderId(),
                                ignored -> new OrderEvent(row.orderId(), row.userId(), row.createTime()))
                        .items.put(row.productName(), row.quantity()));
        return new ArrayList<>(grouped.values());
    }

    private List<String> advancedRecommendations(Long userId,
                                                 List<OrderEvent> trainingOrders,
                                                 List<String> allProducts,
                                                 int limit) {
        Map<Long, Map<String, Double>> userItemMatrix = buildUserItemMatrix(trainingOrders);
        Map<String, Double> targetInteractions = userItemMatrix.getOrDefault(userId, Collections.emptyMap());
        if (targetInteractions.isEmpty()) {
            return popularRecommendations(trainingOrders, allProducts, userId, limit);
        }

        Set<String> purchasedProducts = new HashSet<>(targetInteractions.keySet());
        Map<Long, Double> userSimilarities = calculateUserSimilarities(userId, targetInteractions, userItemMatrix);
        Map<String, Double> collaborativeScores = scoreCandidateProducts(userSimilarities, userItemMatrix, purchasedProducts);

        List<String> ranked = collaborativeScores.entrySet().stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed()
                        .thenComparing(Map.Entry::getKey))
                .map(Map.Entry::getKey)
                .limit(limit)
                .collect(Collectors.toCollection(ArrayList::new));

        if (ranked.size() >= limit) {
            return ranked;
        }

        return supplementWithPopularProducts(ranked, allProducts, trainingOrders, purchasedProducts, limit);
    }

    private List<String> popularRecommendations(List<OrderEvent> trainingOrders,
                                                List<String> allProducts,
                                                Long userId,
                                                int limit) {
        Map<Long, Map<String, Double>> userItemMatrix = buildUserItemMatrix(trainingOrders);
        Set<String> purchasedProducts = new HashSet<>(userItemMatrix.getOrDefault(userId, Collections.emptyMap()).keySet());
        return rankProductsByPopularity(allProducts, trainingOrders, purchasedProducts, Collections.emptySet(), limit);
    }

    private Map<Long, Map<String, Double>> buildUserItemMatrix(List<OrderEvent> orders) {
            Map<Long, Map<String, Double>> userItemMatrix = new HashMap<>();
        for (OrderEvent order : orders) {
            Map<String, Double> itemPreferences = userItemMatrix.computeIfAbsent(order.userId, ignored -> new HashMap<>());
            for (Map.Entry<String, Integer> itemEntry : order.items.entrySet()) {
                itemPreferences.merge(itemEntry.getKey(), (double) Math.max(1, itemEntry.getValue()), Double::sum);
            }
        }
        return userItemMatrix;
    }

    private Map<Long, Double> calculateUserSimilarities(Long userId,
                                                        Map<String, Double> targetInteractions,
                                                        Map<Long, Map<String, Double>> userItemMatrix) {
        Map<Long, Double> userSimilarities = new HashMap<>();
        for (Map.Entry<Long, Map<String, Double>> entry : userItemMatrix.entrySet()) {
            if (userId.equals(entry.getKey())) {
                continue;
            }
            double similarity = cosineSimilarity(targetInteractions, entry.getValue());
            if (similarity > 0D) {
                userSimilarities.put(entry.getKey(), similarity);
            }
        }
        return userSimilarities;
    }

    private Map<String, Double> scoreCandidateProducts(Map<Long, Double> userSimilarities,
                                                       Map<Long, Map<String, Double>> userItemMatrix,
                                                       Set<String> purchasedProducts) {
        Map<String, Double> collaborativeScores = new HashMap<>();
        for (Map.Entry<Long, Double> similarityEntry : userSimilarities.entrySet()) {
            Map<String, Double> otherUserInteractions = userItemMatrix.getOrDefault(similarityEntry.getKey(), Collections.emptyMap());
            for (Map.Entry<String, Double> itemEntry : otherUserInteractions.entrySet()) {
                if (purchasedProducts.contains(itemEntry.getKey())) {
                    continue;
                }
                collaborativeScores.merge(itemEntry.getKey(), similarityEntry.getValue() * itemEntry.getValue(), Double::sum);
            }
        }
        return collaborativeScores;
    }

    private double cosineSimilarity(Map<String, Double> left, Map<String, Double> right) {
        if (left.isEmpty() || right.isEmpty()) {
            return 0D;
        }

        Map<String, Double> smaller = left.size() <= right.size() ? left : right;
        Map<String, Double> larger = smaller == left ? right : left;

        double dotProduct = 0D;
        for (Map.Entry<String, Double> entry : smaller.entrySet()) {
            Double otherValue = larger.get(entry.getKey());
            if (otherValue != null) {
                dotProduct += entry.getValue() * otherValue;
            }
        }
        if (dotProduct == 0D) {
            return 0D;
        }

        double leftNorm = vectorNorm(left.values());
        double rightNorm = vectorNorm(right.values());
        if (leftNorm == 0D || rightNorm == 0D) {
            return 0D;
        }
        return dotProduct / (leftNorm * rightNorm);
    }

    private double vectorNorm(Collection<Double> values) {
        double sum = 0D;
        for (Double value : values) {
            if (value != null) {
                sum += value * value;
            }
        }
        return Math.sqrt(sum);
    }

    private List<String> supplementWithPopularProducts(List<String> collaborativeResults,
                                                       List<String> allProducts,
                                                       List<OrderEvent> trainingOrders,
                                                       Set<String> purchasedProducts,
                                                       int limit) {
        LinkedHashSet<String> existing = new LinkedHashSet<>(collaborativeResults);
        List<String> supplemented = new ArrayList<>(collaborativeResults);
        List<String> popularProducts = rankProductsByPopularity(allProducts, trainingOrders, purchasedProducts, existing, limit);
        for (String product : popularProducts) {
            if (supplemented.size() >= limit) {
                break;
            }
            supplemented.add(product);
        }
        return supplemented;
    }

    private List<String> rankProductsByPopularity(List<String> allProducts,
                                                  List<OrderEvent> trainingOrders,
                                                  Set<String> excludedProducts,
                                                  Set<String> existingProducts,
                                                  int limit) {
        Map<String, Integer> popularity = buildProductPopularity(trainingOrders);
        return allProducts.stream()
                .filter(Objects::nonNull)
                .filter(product -> !excludedProducts.contains(product))
                .filter(product -> !existingProducts.contains(product))
                .sorted(Comparator
                        .comparingInt((String product) -> popularity.getOrDefault(product, 0))
                        .reversed()
                        .thenComparing(product -> product))
                .limit(limit)
                .collect(Collectors.toList());
    }

    private Map<String, Integer> buildProductPopularity(List<OrderEvent> trainingOrders) {
        Map<String, Integer> popularity = new HashMap<>();
        for (OrderEvent order : trainingOrders) {
            for (Map.Entry<String, Integer> itemEntry : order.items.entrySet()) {
                popularity.merge(itemEntry.getKey(), Math.max(1, itemEntry.getValue()), Integer::sum);
            }
        }
        return popularity;
    }

    private List<OrderRow> loadOrderRows(Connection connection) throws Exception {
        String sql = """
                SELECT o.user_id, o.order_id, o.create_time, op.name, op.quantity
                FROM `order` o
                JOIN order_products op ON o.order_id = op.order_id
                ORDER BY o.user_id, o.create_time, op.op_id
                """;

        List<OrderRow> rows = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                rows.add(new OrderRow(
                        resultSet.getLong("user_id"),
                        resultSet.getString("order_id"),
                        resultSet.getTimestamp("create_time").toLocalDateTime(),
                        resultSet.getString("name"),
                        resultSet.getInt("quantity")
                ));
            }
        }
        return rows;
    }

    private List<String> loadAllProducts(Connection connection) throws Exception {
        String sql = "SELECT name FROM product";
        List<String> products = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                products.add(resultSet.getString("name"));
            }
        }
        return products;
    }

    private enum Strategy {
        ADVANCED,
        POPULAR_ONLY
    }

    private record OrderRow(Long userId, String orderId, LocalDateTime createTime, String productName, int quantity) {
    }

    private static final class OrderEvent {
        private final String orderId;
        private final Long userId;
        private final LocalDateTime createTime;
        private final Map<String, Integer> items = new LinkedHashMap<>();

        private OrderEvent(String orderId, Long userId, LocalDateTime createTime) {
            this.orderId = orderId;
            this.userId = userId;
            this.createTime = createTime;
        }
    }

    private record EvaluationResult(int distinctOrderingUsers,
                                    int evaluatedUsers,
                                    double hitRateAtK,
                                    double precisionAtK,
                                    List<String> perUserLines) {
    }
}
