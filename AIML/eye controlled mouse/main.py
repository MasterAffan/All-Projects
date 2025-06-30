import cv2
import mediapipe as mp
import pyautogui
import time
import sys
from typing import Optional, Tuple

class EyeControlledMouse:
    def __init__(self, camera_index: int = 0, smoothing_factor: float = 0.5, click_threshold: float = 0.006):
        """
        Initialize the eye-controlled mouse system.
        
        Args:
            camera_index: Index of the camera to use
            smoothing_factor: Factor for mouse movement smoothing (0-1)r
            click_threshold: Threshold for blink detection
        """
        self.camera_index = camera_index
        self.smoothing_factor = smoothing_factor
        self.click_threshold = click_threshold
        
        # Initialize camera
        self.cam = cv2.VideoCapture(camera_index)
        if not self.cam.isOpened():
            print(f"Error: Could not open camera at index {camera_index}")
            sys.exit(1)
            
        # Initialize MediaPipe Face Mesh
        self.face_mesh = mp.solutions.face_mesh.FaceMesh(
            refine_landmarks=True,
            max_num_faces=1,
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )
        
        # Get screen dimensions
        self.screen_w, self.screen_h = pyautogui.size()
        
        # Previous mouse position for smoothing
        self.prev_x, self.prev_y = self.screen_w // 2, self.screen_h // 2
        
        # Click cooldown
        self.last_click_time = 0
        self.click_cooldown = 1.0  # seconds
        
        print("Eye Controlled Mouse initialized successfully!")
        print(f"Screen resolution: {self.screen_w}x{self.screen_h}")
        print("Press 'q' to quit, 'r' to reset mouse position")
    
    def get_eye_landmarks(self, landmarks) -> Optional[Tuple[int, int]]:
        """
        Extract eye landmarks and calculate screen coordinates.
        
        Args:
            landmarks: MediaPipe face landmarks
            
        Returns:
            Tuple of (screen_x, screen_y) or None if landmarks not found
        """
        try:
            # Get iris landmarks (474-477)
            iris_landmarks = landmarks[474:478]
            
            # Calculate center of iris
            iris_x = sum(landmark.x for landmark in iris_landmarks) / len(iris_landmarks)
            iris_y = sum(landmark.y for landmark in iris_landmarks) / len(iris_landmarks)
            
            return iris_x, iris_y
        except (IndexError, AttributeError):
            return None
    
    def check_blink(self, landmarks) -> bool:
        """
        Check if user is blinking based on eye landmarks.
        
        Args:
            landmarks: MediaPipe face landmarks
            
        Returns:
            True if blink detected, False otherwise
        """
        try:
            # Left eye landmarks for blink detection
            left_eye = [landmarks[145], landmarks[159]]
            
            # Calculate vertical distance between upper and lower eyelid
            blink_distance = abs(left_eye[0].y - left_eye[1].y)
            
            return blink_distance < self.click_threshold
        except (IndexError, AttributeError):
            return False
    
    def smooth_mouse_movement(self, target_x: float, target_y: float) -> Tuple[int, int]:
        """
        Apply smoothing to mouse movement for more stable cursor.
        
        Args:
            target_x: Target x coordinate
            target_y: Target y coordinate
            
        Returns:
            Smoothed coordinates
        """
        # Apply smoothing
        smooth_x = int(self.prev_x * (1 - self.smoothing_factor) + target_x * self.smoothing_factor)
        smooth_y = int(self.prev_y * (1 - self.smoothing_factor) + target_y * self.smoothing_factor)
        
        # Update previous position
        self.prev_x, self.prev_y = smooth_x, smooth_y
        
        return smooth_x, smooth_y
    
    def handle_click(self):
        """Handle mouse click with cooldown."""
        current_time = time.time()
        if current_time - self.last_click_time > self.click_cooldown:
            pyautogui.click()
            self.last_click_time = current_time
            print("Click detected!")
    
    def draw_landmarks(self, frame, landmarks, iris_coords: Optional[Tuple[float, float]]):
        """
        Draw landmarks on the frame for visualization.
        
        Args:
            frame: Video frame
            landmarks: MediaPipe face landmarks
            iris_coords: Iris coordinates
        """
        frame_h, frame_w, _ = frame.shape
        
        # Draw iris landmarks
        if iris_coords:
            iris_x, iris_y = iris_coords
            screen_x = int(iris_x * frame_w)
            screen_y = int(iris_y * frame_h)
            cv2.circle(frame, (screen_x, screen_y), 5, (0, 255, 0), -1)
            cv2.circle(frame, (screen_x, screen_y), 8, (0, 255, 0), 2)
        
        # Draw blink detection landmarks
        try:
            left_eye = [landmarks[145], landmarks[159]]
            for landmark in left_eye:
                x = int(landmark.x * frame_w)
                y = int(landmark.y * frame_h)
                cv2.circle(frame, (x, y), 3, (0, 255, 255), -1)
        except (IndexError, AttributeError):
            pass
    
    def run(self):
        """Main loop for eye-controlled mouse."""
        print("Starting eye-controlled mouse...")
        
        try:
            while True:
                # Read frame
                ret, frame = self.cam.read()
                if not ret:
                    print("Error: Could not read frame from camera")
                    break
                
                # Flip frame horizontally for mirror effect
                frame = cv2.flip(frame, 1)
                
                # Convert to RGB for MediaPipe
                rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                
                # Process with MediaPipe
                output = self.face_mesh.process(rgb_frame)
                landmark_points = output.multi_face_landmarks
                
                if landmark_points:
                    landmarks = landmark_points[0].landmark
                    
                    # Get eye coordinates
                    iris_coords = self.get_eye_landmarks(landmarks)
                    
                    if iris_coords:
                        iris_x, iris_y = iris_coords
                        frame_h, frame_w, _ = frame.shape
                        
                        # Convert to screen coordinates
                        screen_x = int(iris_x * self.screen_w)
                        screen_y = int(iris_y * self.screen_h)
                        
                        # Apply smoothing
                        smooth_x, smooth_y = self.smooth_mouse_movement(screen_x, screen_y)
                        
                        # Move mouse
                        pyautogui.moveTo(smooth_x, smooth_y)
                    
                    # Check for blink
                    if self.check_blink(landmarks):
                        self.handle_click()
                    
                    # Draw landmarks
                    self.draw_landmarks(frame, landmarks, iris_coords)
                
                # Add instructions to frame
                cv2.putText(frame, "Press 'q' to quit, 'r' to reset", (10, 30), 
                           cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)
                
                # Display frame
                cv2.imshow('Eye Controlled Mouse', frame)
                
                # Handle key presses
                key = cv2.waitKey(1) & 0xFF
                if key == ord('q'):
                    break
                elif key == ord('r'):
                    # Reset mouse to center
                    self.prev_x, self.prev_y = self.screen_w // 2, self.screen_h // 2
                    pyautogui.moveTo(self.prev_x, self.prev_y)
                    print("Mouse position reset to center")
        
        except KeyboardInterrupt:
            print("\nInterrupted by user")
        
        finally:
            self.cleanup()
    
    def cleanup(self):
        """Clean up resources."""
        print("Cleaning up...")
        self.cam.release()
        cv2.destroyAllWindows()
        print("Eye Controlled Mouse stopped.")

def main():
    """Main function to run the eye-controlled mouse."""
    try:
        # Create and run eye-controlled mouse
        eye_mouse = EyeControlledMouse(
            camera_index=0,
            smoothing_factor=0.5,
            click_threshold=0.006
        )
        eye_mouse.run()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()