import 'dart:async';

import 'package:dart_chromecast/casting/cast_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chromecast_example/service_discovery.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:observable/observable.dart';

class DevicePicker extends StatefulWidget {
  final ServiceDiscovery serviceDiscovery;
  final Function(CastDevice) onDevicePicked;

  DevicePicker({this.serviceDiscovery, this.onDevicePicked});

  @override
  _DevicePickerState createState() => _DevicePickerState();
}

class _DevicePickerState extends State<DevicePicker> {
  List<CastDevice> _devices = [];
  List<StreamSubscription> _streamSubscriptions = [];

  void initState() {
    super.initState();
    widget.serviceDiscovery.changes.listen((List<ChangeRecord> _) {
      _updateDevices();
    });
    _updateDevices();
  }

  _deviceDidUpdate(CastDevice device) {
    // this device did update, we need to trigger setState
    setState(() => {});
  }

  CastDevice _deviceByName(String name) {
    return _devices.firstWhere((CastDevice d) => d.name == name,
        orElse: () => null);
  }

  CastDevice _castDeviceFromServiceInfo(ServiceInfo serviceInfo) {
    CastDevice castDevice = CastDevice(
        name: serviceInfo.name,
        type: serviceInfo.type,
        host: serviceInfo.address,
        port: serviceInfo.port);
    _streamSubscriptions
        .add(castDevice.changes.listen((_) => _deviceDidUpdate(castDevice)));
    return castDevice;
  }

  _updateDevices() {
    // probably a new service was discovered, so add the new device to the list.
    _devices =
        widget.serviceDiscovery.foundServices.map((ServiceInfo serviceInfo) {
      CastDevice device = _deviceByName(serviceInfo.name);
      if (null == device) {
        device = _castDeviceFromServiceInfo(serviceInfo);
      }
      return device;
    }).toList();
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    CastDevice castDevice = _devices[index];
    return ListTile(
      title: Text(castDevice.friendlyName),
      onTap: () {
        if (null != widget.onDevicePicked) {
          widget.onDevicePicked(castDevice);
          // clean up steam listeners
          _streamSubscriptions.forEach(
              (StreamSubscription subscription) => subscription.cancel());
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a chromecast device'),
      ),
      body: ListView.builder(
        key: Key('devices-list'),
        itemBuilder: _buildListViewItem,
        itemCount: _devices.length,
      ),
    );
  }
}
