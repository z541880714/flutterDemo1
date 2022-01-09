package com.example.flutter_demo1

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlin.random.Random

/**
 *
 * author: Lionel
 * date: 2022-01-03 16:21
 */
class MEventChannelPlugin(val name: String) : EventChannel.StreamHandler {
    lateinit var eventChannel: EventChannel
    lateinit var eventSink: EventChannel.EventSink

    fun register(binaryMessenger: BinaryMessenger) {
        eventChannel = EventChannel(binaryMessenger, name)
        eventChannel.setStreamHandler(this)
    }

    fun sendEvent() {
        if (!this::eventSink.isInitialized) {
            return
        }
        eventSink.success(Random.nextInt())
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        println("onListen:  start listen event channel !!!")
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        arguments ?: return

    }
}