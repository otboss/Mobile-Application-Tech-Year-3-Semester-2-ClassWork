package com.example.otto.myapplication;

import android.annotation.TargetApi;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.Gson;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;


public class MainActivity extends AppCompatActivity {

    Gson gson = new Gson();
    FlaskServerResponse res = new FlaskServerResponse(true, 0, 0, null, null);
    private RecyclerView recyclerView;
    private RecyclerView.Adapter mAdapter;
    private RecyclerView.LayoutManager layoutManager;

    /*SENDS A REQUEST AND EXPECTS JSON RESPONSE*/
    private FlaskServerResponse sendJsonRequest(String url){
        RequestQueue queue = Volley.newRequestQueue(this);
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                // Display the first 500 characters of the response string.
                Log.i("myApp","Response is: "+ response.substring(0,500));
                res = gson.fromJson(response, FlaskServerResponse.class);
                res.isNull = false;
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.i("myApp","That didn't work!");
                throw new Error("Error Here");
            }
        });
        queue.add(stringRequest);
        return null;
    }

    @TargetApi(Build.VERSION_CODES.N)
    @RequiresApi(api = Build.VERSION_CODES.N)
    private CompletableFuture<StringRequest> sendRequest(String url){
        CompletableFuture<StringRequest> response = new CompletableFuture<>();

        Executors.newCachedThreadPool().submit(()-> {
            response.complete(new StringRequest(Request.Method.GET, url, response1 -> {
                // Display the first 500 characters of the response string.
                Log.i("myApp","Response is: "+ response1.substring(0,500));
                res = gson.fromJson(response1, FlaskServerResponse.class);
                res.isNull = false;
            }, error -> {
                Log.i("myApp","That didn't work!");
                throw new Error("Error Here");
            }));
            return null;
        });
        return response;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        recyclerView = (RecyclerView) findViewById(R.id.my_recycler_view);
        recyclerView.setHasFixedSize(true);
        layoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(layoutManager);
        //TODO: Implement using CompletableFuture<V>. The following implementation will hand the main thread!
        sendJsonRequest("https://jsonplaceholder.typicode.com/todos/1");
        while(res.isNull){
            //WAITING ON SERVER RESPONSE..
        }
        //sendRequest("https://jsonplaceholder.typicode.com/todos/1").complete();
        res.isNull = true;

        //Load the results onto the screen




    }
}
