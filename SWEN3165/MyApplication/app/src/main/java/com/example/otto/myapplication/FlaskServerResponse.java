package com.example.otto.myapplication;

public class FlaskServerResponse {

    Boolean isNull = true, completed = false;
    int userId, id;
    String title;

    FlaskServerResponse(Boolean isNull, int userId, int id, String title, Boolean completed){
        this.isNull = isNull;
        this.completed = completed;
        this.userId = userId;
        this.id = id;
        this.title = title;
    }
}
