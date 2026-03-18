# C5680 Streak Camera Epics IOC

This Input/Output Controller (IOC) implements a StreamDevice EPICS IOC to communicate with the Hamamatsu Streak Camera. It uses WebSocket communication with the RemoteEx Program, which must be open for the system to function correctly.

## Requirements

To run the IOC, ensure the following packages are installed:
* EPICS, version >= R3.15.9
* Streamdevice, version >= 2.8.16

## Running the application 

To run the IOC, follow these steps:
1. *Adjust the Execution Path:* In the `st.cmd` file located in `ioc/iocBoot`, update the execution path to where StreamDevice is installed. For example:
```
#!/opt/epics-R3.15.9/modules/StreamDevice-2.8.16/bin/linux-x86_64/streamApp
```
2. *Set Environment Variables:* In the same st.cmd file, set the IOC and STREAMDEVICE environment variables to point to the root directories of the IOC and StreamDevice module, respectively.
3. *Check IP and Port:* Ensure the IP and port in the `PS1` variable match the computer's IP where the RemoteEx Program is running.
4. *Run the IOC:*
    * Check that RemoteEx Program is opened in the computer which the Streak Camera is connected.
    * Executes the `st.cmd` file to start the IOC.
    * Alternatively, use the `streakcamera-epics-ioc.service` file in the `etc` folder to create and run an application service.

By following these steps, you can ensure that the IOC communicates correctly with the Hamamatsu Streak Camera.

## Process Variables Description

|    Process Variable    |  Type  | Parameter | Description |
|:----------------------:|:------:|:---------:|:-----------:|
| SC:App:Start-Cmd | Stream | float | With the RemoteEx program opened in the computer where the StreakCamera is connected, sets a generic value to this PVs call a function that opens the software of the StreakCamera |
|     SC:App:End-Cmd     | Stream |   float   | Closes the software of the StreakCamera |
| SC:AcqParams:Start-Cmd | Stream |    int    | Starts an acquisiton in the camera. When executed, the user can pass  the following parameters: 0 (Live), 1 (Acquire), 2 (AI), and 3 (PC) |
| SC:Lut:SetAuto-Cmd | Stream | float | Executes AutoLut functions to adjust the image contrast |
| SC:ImgParams:CreateVerRectRoi-Cmd | Stream | float | Crates a vertical ROI in a image using the parameters that was configured in `SC:ImgParams:RoiIniX-SP` for initial x point, `SC:ImgParams:RoiWidthX-SP` for ROI width, and `SC:ImgParams:ImageHeight-Mon` for ROI height |
| SC:GenParams:TimeRange-SP | stream | int | Sets the device time range |
| SC:GenParams:Mode-SP | stream | int | Sets the operation mode of the camera. This parameter can be 0: Focus or 1: Operate |
| SC:GenParams:MCPGain-SP | stream | int | Sets the device MCP Gain |
| SC:GenParams:Shutter-SP | stream | int | Sets the status of the shutter. This parameter can be 0 (Closed) or 1 (Open) |
| SC:GenParams:BlankingAmp-SP | stream | int | Sets the Blanking Amp time. This parameter can be 0: off, 1: 100 ns, 2: 200 ns, 3: 500 ns, 4: 1 us, 5: 2 us, 6: 5 us, 7: 10 us, 8: 20 us, 9: 50 us, 10: 100 us, 11: 200 us, 12: 500 us, 13: 1 ms, 14: 2 ms, and 15: 5 ms |
| SC:GenParams:HTrigStatus-SP | stream | int | Sets the horizontal trigger status of the camera. This parameter can be 0 (Ready), 1 (Fired), and 2 (Do Reset) |
| SC:GenParams:HTrigMode-SP | stream | int | Sets the mode of horizontal trigger. This parameter can be 0 (Cont) or 1 (Single) |
| SC:GenParams:HTrigLevel-SP | stream | int | Sets the level of the horizontal trigger |
| SC:GenParams:Delay-SP | stream | int | Sets the device delay |
| SC:GenParams:FocusTimeOver-SP | stream | int | Sets the maximum time that the shutter will stay opened |
| SC:CamParams:Exposure-SP | stream | float | Sets the camera exposure |
| SC:ImgParams:RoiIniX-SP | stream | float | Initial x-point of ROI |
| SC:ImgParams:RoiIniY-SP | stream | float | Initial y-point of ROI |
| SC:ImgParams:RoiWidthX-SP | stream | float | ROI width |
| SC:ImgParams:RoiWidthY-SP | stream | float | ROI height |
| SC:ImgParams:ImageHeight-Mon | analog input | float | Monitors the captured image height |
| SC:ImgParams:ImageWidth-Mon | stream | float | Monitor the captured image width |
| SC:ImgParams:ImageOpened-Mon | stream | bool | Monitor if there is an image opened |
| SC:ImgProfile:FHWM-Mon | stream | float | Monitor the full width at half maximum if possible |

*Notes:*
* All process variables that are indicated with the SP (Setpoint) flag have a respective variable with RB (Readback) termination for reading the values ​​that are configured.

## Example of Use

### Getting FHWM from a captured image

1. With RemoteEx Program opened, open the Streak Camera program:
```
caput SC:App:Start-Cmd 1
```

2. Adjust some parameters associated with the capture:
```
caput SC:GenParams:FocusTimeOver-SP 1
caput SC:GenParams:Mode-SP 1
caput SC:GenParams:TimeRange-SP 4
caput SC:GenParams:BlankingAmp-SP 0
```

3. Start capture in `acquire` mode:
```
caput SC:AcqParams:Start-Cmd 1
```

4. Adjust the contrast:
```
caput SC:Lut:SetAuto-Cmd 1
```

5. Define the region of interest and create:
```
caput SC:ImgParams:RoiIniX-SP 630
caput SC:ImgParams:RoiIniY-SP 0
caput SC:ImgParams:RoiWidthX-SP 150
caput SC:ImgParams:RoiWidthY-SP 1024
caput SC:ImgParams:CreateVerRectRoi-Cmd 1
```

6. Monitor the variable of interest:
```
caget SC:ImgProfile:FHWM-Mon
```