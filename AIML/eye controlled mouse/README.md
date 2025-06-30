# Eye Controlled Mouse 

A Python application that allows you to control your computer's mouse cursor using eye movements and blinks. This project uses computer vision and machine learning to track your eyes and translate their movements into mouse cursor movements.

## Features

- **Eye Tracking**: Real-time tracking of eye movements using MediaPipe Face Mesh
- **Mouse Control**: Precise cursor control based on iris position
- **Blink Detection**: Click functionality triggered by blinking
- **Smooth Movement**: Configurable smoothing algorithm for stable cursor movement
- **Visual Feedback**: Real-time visualization of eye landmarks and tracking
- **Error Handling**: Robust error handling and graceful shutdown
- **Configurable Parameters**: Adjustable sensitivity, smoothing, and click thresholds
- **Keyboard Controls**: Easy-to-use keyboard shortcuts for control

## Technologies Used

- **Python 3.7+**: Core programming language
- **OpenCV (cv2)**: Computer vision library for camera capture and image processing
- **MediaPipe**: Google's ML framework for face mesh detection and landmark tracking
- **PyAutoGUI**: Cross-platform GUI automation for mouse control
- **NumPy**: Numerical computing (dependency of OpenCV and MediaPipe)

## Requirements

- Python 3.7 or higher
- Webcam or camera device
- Windows, macOS, or Linux operating system
- Adequate lighting for face detection

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd eye-controlled-mouse
   ```

2. **Install required packages**:
   ```bash
   pip install opencv-python mediapipe pyautogui numpy
   ```

   Or install using the requirements file:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application**:
   ```bash
   python main.py
   ```

## Usage

### Basic Operation

1. **Start the application**: Run `python main.py`
2. **Position yourself**: Sit in front of your camera with good lighting
3. **Eye tracking**: The application will track your iris movement
4. **Mouse control**: Move your eyes to control the cursor
5. **Clicking**: Blink to perform a mouse click
6. **Exit**: Press 'q' to quit the application

### Controls

- **Eye Movement**: Control mouse cursor position
- **Blink**: Perform mouse click (with 1-second cooldown)
- **'q' key**: Quit the application
- **'r' key**: Reset mouse position to screen center

### Configuration

You can modify the following parameters in the `main.py` file:

```python
eye_mouse = EyeControlledMouse(
    camera_index=0,        # Camera device index
    smoothing_factor=0.5,  # Mouse movement smoothing (0-1)
    click_threshold=0.006  # Blink detection sensitivity
)
```

## 🔧 Customization

### Adjusting Sensitivity

- **Smoothing Factor**: Lower values (0.1-0.3) for more responsive movement, higher values (0.7-0.9) for smoother movement
- **Click Threshold**: Lower values for more sensitive blink detection, higher values for less sensitive detection

### Camera Settings

- Change `camera_index` to use different cameras
- Ensure adequate lighting for better face detection
- Position yourself 20-50cm from the camera

## Project Structure

```
eye-controlled-mouse/
├── main.py              # Main application file
├── README.md           # Project documentation
└── requirements.txt    # Python dependencies
```

## Troubleshooting

### Common Issues

1. **Camera not detected**:
   - Check if your camera is connected and working
   - Try different `camera_index` values (0, 1, 2, etc.)
   - Ensure no other application is using the camera

2. **Poor tracking accuracy**:
   - Improve lighting conditions
   - Clean your camera lens
   - Position yourself closer to the camera
   - Adjust smoothing factor

3. **Accidental clicks**:
   - Increase `click_threshold` value
   - Reduce sensitivity for blink detection

4. **Performance issues**:
   - Close other resource-intensive applications
   - Reduce camera resolution if needed
   - Use a more powerful computer

## Privacy & Security

- This application processes video locally on your computer
- No video data is transmitted or stored
- Camera access is only used for eye tracking
- You can disconnect your camera when not in use

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This application is for educational and accessibility purposes. Please use responsibly and ensure you have proper lighting and positioning for optimal performance. 