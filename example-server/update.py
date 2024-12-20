import os
import time
from pathlib import Path

def monitor_file(file_path):
    """
    Monitor file modifications and write UTC timestamp to 'version' file.
    
    Args:
        file_path (str): Path to the file to monitor
    """
    file_path = Path(file_path)
    version_path = file_path.parent / 'version'
    
    if not file_path.exists():
        raise FileNotFoundError(f"File not found: {file_path}")
    
    last_mtime = None
    
    try:
        while True:
            current_mtime = int(os.path.getmtime(file_path))
            
            if last_mtime != current_mtime:
                # Convert to UTC timestamp
                utc_timestamp = int(time.time())
                
                # Write timestamp to version file
                with open(version_path, 'w') as f:
                    f.write(str(utc_timestamp))
                    
                last_mtime = current_mtime
            
            time.sleep(3)
            
    except KeyboardInterrupt:
        print("\nMonitoring stopped")
    except Exception as e:
        print(f"Error occurred: {e}")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) != 2:
        print("Usage: python script.py <file_path>")
        sys.exit(1)
        
    monitor_file(sys.argv[1])