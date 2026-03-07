package com.example.auth_service.repository;

import com.example.auth_service.model.User;
import org.springframework.stereotype.Repository;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.Key;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;

@Repository
public class UserRepository {
    private final DynamoDbTable<User> userTable;

    public UserRepository(DynamoDbEnhancedClient dynamoDbEnhancedClient) {
        // map user table based on User.java
        this.userTable = dynamoDbEnhancedClient
            .table("Users", TableSchema.fromBean(User.class));
    }

    public void saveUser(User user) {
        userTable.putItem(user);
    }

    public User getUserByUsername(String username) {
        // get the partition value from username
        Key usernamekey = Key.builder().partitionValue(username).build();
        return userTable.getItem(usernamekey);
    }
}
