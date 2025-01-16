/*
 * This file is auto-generated.  DO NOT MODIFY.
 */
package com.sunmi.scanner;
public interface IScanInterface extends android.os.IInterface
{
  /** Default implementation for IScanInterface. */
  public static class Default implements com.sunmi.scanner.IScanInterface
  {
    /**
     * key.getAction()==KeyEvent.ACTION_UP
     * key.getAction()==KeyEvent.ACTION_DWON
     */
    @Override public void sendKeyEvent(android.view.KeyEvent key) throws android.os.RemoteException
    {
    }
    /** */
    @Override public void scan() throws android.os.RemoteException
    {
    }
    /** */
    @Override public void stop() throws android.os.RemoteException
    {
    }
    /**
     * 100-->NONE
     * 101-->P2Lite
     * 102-->l2-newland
     * 103-->l2-zebra
     */
    @Override public int getScannerModel() throws android.os.RemoteException
    {
      return 0;
    }
    @Override
    public android.os.IBinder asBinder() {
      return null;
    }
  }
  /** Local-side IPC implementation stub class. */
  public static abstract class Stub extends android.os.Binder implements com.sunmi.scanner.IScanInterface
  {
    /** Construct the stub at attach it to the interface. */
    public Stub()
    {
      this.attachInterface(this, DESCRIPTOR);
    }
    /**
     * Cast an IBinder object into an com.sunmi.scanner.IScanInterface interface,
     * generating a proxy if needed.
     */
    public static com.sunmi.scanner.IScanInterface asInterface(android.os.IBinder obj)
    {
      if ((obj==null)) {
        return null;
      }
      android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
      if (((iin!=null)&&(iin instanceof com.sunmi.scanner.IScanInterface))) {
        return ((com.sunmi.scanner.IScanInterface)iin);
      }
      return new com.sunmi.scanner.IScanInterface.Stub.Proxy(obj);
    }
    @Override public android.os.IBinder asBinder()
    {
      return this;
    }
    @Override public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
    {
      java.lang.String descriptor = DESCRIPTOR;
      if (code >= android.os.IBinder.FIRST_CALL_TRANSACTION && code <= android.os.IBinder.LAST_CALL_TRANSACTION) {
        data.enforceInterface(descriptor);
      }
      switch (code)
      {
        case INTERFACE_TRANSACTION:
        {
          reply.writeString(descriptor);
          return true;
        }
      }
      switch (code)
      {
        case TRANSACTION_sendKeyEvent:
        {
          android.view.KeyEvent _arg0;
          _arg0 = _Parcel.readTypedObject(data, android.view.KeyEvent.CREATOR);
          this.sendKeyEvent(_arg0);
          reply.writeNoException();
          break;
        }
        case TRANSACTION_scan:
        {
          this.scan();
          reply.writeNoException();
          break;
        }
        case TRANSACTION_stop:
        {
          this.stop();
          reply.writeNoException();
          break;
        }
        case TRANSACTION_getScannerModel:
        {
          int _result = this.getScannerModel();
          reply.writeNoException();
          reply.writeInt(_result);
          break;
        }
        default:
        {
          return super.onTransact(code, data, reply, flags);
        }
      }
      return true;
    }
    private static class Proxy implements com.sunmi.scanner.IScanInterface
    {
      private android.os.IBinder mRemote;
      Proxy(android.os.IBinder remote)
      {
        mRemote = remote;
      }
      @Override public android.os.IBinder asBinder()
      {
        return mRemote;
      }
      public java.lang.String getInterfaceDescriptor()
      {
        return DESCRIPTOR;
      }
      /**
       * key.getAction()==KeyEvent.ACTION_UP
       * key.getAction()==KeyEvent.ACTION_DWON
       */
      @Override public void sendKeyEvent(android.view.KeyEvent key) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _Parcel.writeTypedObject(_data, key, 0);
          boolean _status = mRemote.transact(Stub.TRANSACTION_sendKeyEvent, _data, _reply, 0);
          _reply.readException();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
      }
      /** */
      @Override public void scan() throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          boolean _status = mRemote.transact(Stub.TRANSACTION_scan, _data, _reply, 0);
          _reply.readException();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
      }
      /** */
      @Override public void stop() throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          boolean _status = mRemote.transact(Stub.TRANSACTION_stop, _data, _reply, 0);
          _reply.readException();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
      }
      /**
       * 100-->NONE
       * 101-->P2Lite
       * 102-->l2-newland
       * 103-->l2-zebra
       */
      @Override public int getScannerModel() throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        int _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          boolean _status = mRemote.transact(Stub.TRANSACTION_getScannerModel, _data, _reply, 0);
          _reply.readException();
          _result = _reply.readInt();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
    }
    static final int TRANSACTION_sendKeyEvent = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
    static final int TRANSACTION_scan = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
    static final int TRANSACTION_stop = (android.os.IBinder.FIRST_CALL_TRANSACTION + 2);
    static final int TRANSACTION_getScannerModel = (android.os.IBinder.FIRST_CALL_TRANSACTION + 3);
  }
  public static final java.lang.String DESCRIPTOR = "com.sunmi.scanner.IScanInterface";
  /**
   * key.getAction()==KeyEvent.ACTION_UP
   * key.getAction()==KeyEvent.ACTION_DWON
   */
  public void sendKeyEvent(android.view.KeyEvent key) throws android.os.RemoteException;
  /** */
  public void scan() throws android.os.RemoteException;
  /** */
  public void stop() throws android.os.RemoteException;
  /**
   * 100-->NONE
   * 101-->P2Lite
   * 102-->l2-newland
   * 103-->l2-zebra
   */
  public int getScannerModel() throws android.os.RemoteException;
  /** @hide */
  static class _Parcel {
    static private <T> T readTypedObject(
        android.os.Parcel parcel,
        android.os.Parcelable.Creator<T> c) {
      if (parcel.readInt() != 0) {
          return c.createFromParcel(parcel);
      } else {
          return null;
      }
    }
    static private <T extends android.os.Parcelable> void writeTypedObject(
        android.os.Parcel parcel, T value, int parcelableFlags) {
      if (value != null) {
        parcel.writeInt(1);
        value.writeToParcel(parcel, parcelableFlags);
      } else {
        parcel.writeInt(0);
      }
    }
  }
}
