package com.example.flutter_demo1

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.*
import java.nio.ByteBuffer
import kotlin.concurrent.thread
import kotlin.random.Random

class MainActivity : FlutterActivity() {

    //FlutterView 组件
    private val flutterView: FlutterView by lazy { findViewById<FlutterView>(R.id.id_layout_main_activity) }

    private val mBinaryMessage get() = flutterEngine!!.dartExecutor.binaryMessenger

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_layout)
        //在 原生 Layout 中 嵌入 Flutterview 与  flutter 进行交互
        flutterView.attachToFlutterEngine(flutterEngine!!)

        val messageChannel = BasicMessageChannel<String>(
            flutterEngine!!.dartExecutor.binaryMessenger,
            "test",
            StringCodec.INSTANCE
        ).apply {
            setMessageHandler { message, reply ->
                println("zzzz  message: $message")
            }
        }
        messageChannel.send("hello flutter !!")

        val eventChannel =
            MEventChannelPlugin("event_channel_1")
        eventChannel.register(flutterEngine!!.dartExecutor.binaryMessenger)


        thread {
            while (true) {
                runOnUiThread {
                    eventChannel.sendEvent()
                    messageChannel.send("hahahahahaha")
                }
                Thread.sleep(1000)
            }
        }
    }
}
