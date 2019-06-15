package com.example.loginandregisteruser;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.RequestFuture;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

enum LoginStatus{
    InvalidCredentials,
    ConnectionError,
    ServerDidNotRespond,
    LoginSuccessful,
    Unset
}

enum RegistrationStatus{
    InvalidCredentials,
    ConnectionError,
    ServerDidNotRespond,
    RegistrationSuccessful,
    Unset
}

public class Task extends Activity {
    private ExecutorService executorService = Executors.newSingleThreadExecutor();
    public LoginStatus loginResult = LoginStatus.Unset;
    public RegistrationStatus registrationResult = RegistrationStatus.Unset;
    private String api = "http://127.0.0.1:5000/";
    private String username, password, confirmpassword;
    //private Gson gson = new Gson();

    private Callable<String> loginExec = new Callable<String>(){
        @Override
        public String call() throws Exception {
            // Perform some async computation
            RequestFuture<JSONObject> future = RequestFuture.newFuture();
            JSONObject payload = new JSONObject();
            payload.put("username", username);
            payload.put("password", password);
            JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, api+"login", payload, future, future);
            try{
                JSONObject response = future.get(10000, TimeUnit.MILLISECONDS);
                int result = Integer.parseInt(response.toString());
                switch(result){
                    case 1:
                        return LoginStatus.LoginSuccessful.toString();
                    default:
                        return LoginStatus.ConnectionError.toString();
                }
            }
            catch(Exception e){
                Log.e("Exception", e.toString());
                return LoginStatus.Unset.toString();
            }
        }
    };

    private Callable<String> registrationExec = new Callable<String>(){
        @Override
        public String call() throws Exception {
            // Perform some async computation
            RequestFuture<JSONObject> future = RequestFuture.newFuture();
            JSONObject payload = new JSONObject();
            payload.put("username", username);
            payload.put("password", password);
            payload.put("confirmpassword", confirmpassword);
            JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST,api+"register", payload, future, future);
            try{
                JSONObject response = future.get(10000, TimeUnit.MILLISECONDS);
                int result = Integer.parseInt(response.toString());
                switch(result){
                    case 1:
                        return RegistrationStatus.RegistrationSuccessful.toString();
                    default:
                        return RegistrationStatus.ConnectionError.toString();
                }
            }
            catch(Exception e){
                Log.e("Exception", e.toString());
                return LoginStatus.Unset.toString();
            }
        }
    };


    Task(Boolean isLogin, String username, String password, String confirmpassword) throws ExecutionException, InterruptedException {
        if(isLogin){
            //LOGIN TASK
            this.username = username;
            this.password = password;
            Future<String> response = executorService.submit(loginExec);
            this.loginResult = LoginStatus.valueOf(response.get());
        }
        else{
            //REGISTRATION TASK
            this.username = username;
            this.password = password;
            this.confirmpassword = confirmpassword;
            Future<String> response = executorService.submit(registrationExec);
            this.registrationResult = RegistrationStatus.valueOf(response.get());
        }
    }
}


