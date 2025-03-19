package com.opalposinc.app

import android.Manifest
import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Message
import android.os.Parcelable
import android.util.Log
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.example.opalposinc.GlobalContants
import com.hcd.hcdpos.cashbox.Cashbox // Import for Cash Drawer functionality
import com.printer.sdk.PrinterConstants
import com.printer.sdk.PrinterConstants.Connect
import com.printer.sdk.PrinterConstants.PAlign
import com.printer.sdk.PrinterInstance
import com.printer.sdk.mupdf.MuPDFCore
import com.printer.sdk.usb.USBPort
import com.printer.sdk.utils.PrefUtils
import com.printer.sdk.utils.Utils
import com.printer.sdk.utils.XLog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

open class MainActivity: FlutterActivity() {
   
    private val PRINT_CHANNEL = "com.org.kotlin_specifics/print"
    private val CASH_DRAWER_CHANNEL = "com.example.app/drawerChannel"
    
    private lateinit var mContext: Context
    var myPrinter: PrinterInstance? = null
    var mUSBDevice: UsbDevice? = null
    var isConnected: Boolean = false
    var devicesName: String = "Unknown Device"
    private var deviceList: List<UsbDevice>? = null
    private val TAG: String = "MainActivity"
    private val ACTION_USB_PERMISSION: String = "com.android.usb.USB_PERMISSION"
    private var bitmap: Bitmap? = null

    private val tvShowPage: TextView? = null
    private var currentCount = -1
    private var pageCount = -1
    private val ivShowPdf: ImageView? = null

    var PERMISSIONS_STORAGE: Array<String> = arrayOf(
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.WRITE_EXTERNAL_STORAGE,
        Manifest.permission.ACCESS_COARSE_LOCATION,
        Manifest.permission.ACCESS_FINE_LOCATION,
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mContext = applicationContext
        val manager = getSystemService(USB_SERVICE) as UsbManager
        usbAutoConn(manager)
        PrinterConstants.paperWidth = 724
        PrinterConstants.paperWidth = PrefUtils.getInt(
            mContext,
            GlobalContants.PAPERWIDTH,
            724
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Handle print functionality
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PRINT_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "printPdf") {
                val path = call.argument<String>("path")
                if (path != null) {
                    printPdf(path) // Implement your PDF printing logic here
                    result.success("PDF printing started")
                } else {
                    result.error("UNAVAILABLE", "Path not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Handle cash drawer opening functionality
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CASH_DRAWER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "cashDrawerOpen") {
                Cashbox.doOpenCashBox() // Implement your cash drawer opening logic here
                result.success("Successfully opened drawer")
            } else {
                result.notImplemented()
            }
        }
    }
    

    @Deprecated("Deprecated in Java")
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
             super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSION_CODE) {
            var isAllGranted = true
            // 判断是否所有的权限都已经授予了
            for (i in grantResults.indices) {
                val grant = grantResults[i]
                if (grant != PackageManager.PERMISSION_GRANTED) {
                    XLog.d(
                        "yxz",
                        "yxz at MainActivity.java checkPermissionAllGranted() permissions[" + i + "]：" + permissions[i] + "授权未成功"
                    )
                    isAllGranted = false
                    break
                }
            }
            if (!isAllGranted) {
                // 弹出对话框告诉用户需要权限的原因, 并引导用户去应用权限管理中手动打开权限按钮
                Toast.makeText(
                    mContext,
                    "Permission Not Granted",
                    Toast.LENGTH_SHORT
                ).show()
                return
            }
            return
        }
    }

    fun checkPermissionAllGranted(perssions: Array<String>): Boolean {
        for (perssion in perssions) {
            if (ActivityCompat.checkSelfPermission(
                    this,
                    perssion
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                XLog.d(
                    "yxz",
                    "yxz at MainActivity.java checkPermissionAllGranted() perssion：" + "没有权限"
                )
                return false
            }
        }
        return true
    }

    companion object {
        private const val REQUEST_PERMISSION_CODE = 200
        val ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION"
    }

    private val mUsbReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        @SuppressLint("NewApi")
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            Log.w(TAG, "receiver action: $action")

            if (ACTION_USB_PERMISSION == action) {
                synchronized(this) {
                    mContext.unregisterReceiver(this)
                    val device =
                        intent.getParcelableExtra<Parcelable>(UsbManager.EXTRA_DEVICE) as UsbDevice?
                    if (intent.getBooleanExtra(
                            UsbManager.EXTRA_PERMISSION_GRANTED,
                            false
                        ) && mUSBDevice == device
                    ) {
                        myPrinter?.openConnection()
                    } else {

                        Log.e(
                            TAG,
                            "permission denied for device $device"
                        )
                    }
                }
            }
        }
    }

    private class MyHandler(activity: MainActivity) : Handler() {
        private val activityReference: java.lang.ref.WeakReference<MainActivity> =
            java.lang.ref.WeakReference(activity)

        @SuppressLint("ShowToast")
        override fun handleMessage(msg: Message) {
            val activity = activityReference.get()
            when (msg.what) {
                Connect.SUCCESS -> {
                    activity?.isConnected = true
                    GlobalContants.ISCONNECTED = activity?.isConnected == true
                    GlobalContants.DEVICENAME = activity?.devicesName
                }

                Connect.FAILED -> {
                    activity?.isConnected = false
                    Toast.makeText(
                        activity?.mContext,
                        R.string.conn_failed,
                        Toast.LENGTH_SHORT
                    ).show()
                    XLog.i(
                        activity?.TAG,
                        "ZL at SettingActivity Handler() 连接失败!"
                    )
                }

                Connect.CLOSED -> {
                    activity?.isConnected = false
                    GlobalContants.ISCONNECTED = activity?.isConnected == true
                    GlobalContants.DEVICENAME = activity?.devicesName
                    Toast.makeText(
                        activity?.mContext,
                        R.string.conn_closed,
                        Toast.LENGTH_SHORT
                    ).show()
                    XLog.i(
                        activity?.TAG,
                        "ZL at SettingActivity Handler() 连接关闭!"
                    )
                }

                Connect.NODEVICE -> {
                    activity?.isConnected = false
                    Toast.makeText(
                        activity?.mContext,
                        R.string.conn_no,
                        Toast.LENGTH_SHORT
                    ).show()
                }

                else -> {}
            }
        }
    }

    private val mHandler: Handler = MyHandler(this)

    @SuppressLint("InlinedApi", "NewApi")
    fun usbAutoConn(manager: UsbManager) {

        doDiscovery(manager)
        if (deviceList!!.isEmpty()) {
            Toast.makeText(mContext, R.string.no_connected, Toast.LENGTH_SHORT)
                .show()
            return
        }
        mUSBDevice = deviceList!![0]

        myPrinter = PrinterInstance.getPrinterInstance(
            mContext,
            mUSBDevice,
            mHandler
        )
        devicesName =
            mUSBDevice!!.getDeviceName()
        Toast.makeText(mContext, devicesName, Toast.LENGTH_SHORT)
            .show()

        val mUsbManager = mContext.getSystemService(USB_SERVICE) as UsbManager
        if (mUsbManager.hasPermission(mUSBDevice)) {
            myPrinter?.openConnection()
        } else {
            // 没有权限询问用户是否授予权限
            var pendingIntent: PendingIntent?
            pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.getBroadcast(mContext, 0, Intent(ACTION_USB_PERMISSION), android.app.PendingIntent.FLAG_IMMUTABLE)
            } else {
                PendingIntent.getBroadcast(
                    mContext,
                    0,
                    Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE
                )
            }
            val filter: IntentFilter =
                IntentFilter(ACTION_USB_PERMISSION)
            filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED)
            filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
            mContext.registerReceiver(mUsbReceiver, filter)
            mUsbManager.requestPermission(
                mUSBDevice,
                pendingIntent
            ) // 该代码执行后，系统弹出一个对话框
        }
    }

    @SuppressLint("NewApi")
    private fun doDiscovery(manager: UsbManager) {
        val devices = manager.deviceList
        deviceList = ArrayList()
        for (device in devices.values) {
            if (USBPort.isUsbPrinter(device)) {
                (deviceList as ArrayList<UsbDevice>).add(device)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mContext.unregisterReceiver(mUsbReceiver)
    }

    private var core: MuPDFCore? = null
    open var count: Int = 0
    open var pageData: MutableList<ByteArray>? = null

    fun printPdf(path: String?) {
        if (path == null) {
            Toast.makeText(
                this,
                getString(R.string.choose_pdf_file),
                Toast.LENGTH_SHORT
            ).show()
            return
        }

        runOnUiThread {

            Log.e("file path ", "${path}")
            try {
                core = MuPDFCore(this, path)
            } catch (e: Exception) {
                e.printStackTrace()
                Log.e("error stack ", "${e.message}")
            }

            pageCount = core!!.countPages()

            Log.i(
                TAG,
                "yxz at PdfPrintActivity.java onActivityResult() pageCount:$pageCount"
            )
            currentCount = 0
            Log.i(
                TAG,
                "yxz at PdfPrintActivity.java onActivityResult() currentCount:$currentCount"
            )

            Log.i(
                "mainactivity",
                "zl --getAllFiles()----fileAdapter.add(f.getAbsolutePath()):"
                        + path
            )
        }

        Toast.makeText(
            this,
            getString(R.string.toast_print_all_pdf),
            Toast.LENGTH_SHORT
            ).show()

        // 打印整份pdf
        preloadPDF()

        // 打印整份pdf
        Log.i(
            TAG,
            "yxz at PdfPrintActivity.java onClick() case R.id.btn_printpdf: pdf文件共有 " + pageCount + "页"
        )
        var countIndex = 0
        while (countIndex < pageCount) {
            Log.d("pages", pageCount.toString())
            if (!pageData!!.isEmpty()) {
                PrinterInstance.mPrinter.sendBytesData(pageData!![0])
                pageData!!.removeAt(0)
                countIndex++
            }
        }}

    private fun preloadPDF() { // 预加载PDF
        count = 0
        pageData = ArrayList()
        Thread(object : Runnable {
            override fun run() {
                synchronized(this) {
                    while (count < pageCount) {
                        val pageSize = core!!.getPageSize(count)
                        val pageW = pageSize.x
                        val pageH = pageSize.y
                        bitmap = Bitmap.createBitmap(
                            pageW.toInt(),
                            pageH.toInt(),
                            Bitmap.Config.ARGB_8888
                        )
                        core!!.drawPage(
                            count,
                            bitmap,
                            pageW.toInt(),
                            pageH.toInt(),
                            0,
                            0,
                            pageW.toInt(),
                            pageH.toInt()
                        )
                        if (bitmap!!.width > PrinterConstants.paperWidth) {
                            bitmap = Utils.zoomImage(
                                bitmap,
                                PrinterConstants.paperWidth.toDouble(),
                                PrefUtils.getInt(
                                    applicationContext,
                                    GlobalContants.PRINTERTYPE,
                                    0
                                )
                            )
                        }
                        bitmap = Utils.zoomImage(
                            bitmap,
                            816.0,
                            PrefUtils.getInt(
                                applicationContext,
                                GlobalContants.PRINTERTYPE,
                                0
                            )
                        )
                        (pageData as ArrayList<ByteArray>).add(
                            Utils.originalBmpToPrintByte(
                                bitmap,
                                PAlign.NONE,
                                0,
                                128
                            )
                        )
                        count++
                    }
                }
            }
        }).start()
    }
}