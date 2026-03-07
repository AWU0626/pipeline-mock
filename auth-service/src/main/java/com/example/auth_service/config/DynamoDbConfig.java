package com.example.auth_service.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Configuration
public class DynamoDbConfig {

    @Value("${aws.region}") // extract region from properties
    private String region;

    @Bean
    public DynamoDbEnhancedClient dynamoDbEnhancedClient() {
        // enhanced client handles mapping directly from User class
        DynamoDbClient dynamoDbClient = DynamoDbClient.builder()
            .region(Region.of(region))
            .build();

        return DynamoDbEnhancedClient
            .builder()
            .dynamoDbClient(dynamoDbClient)
            .build();

    }
}
