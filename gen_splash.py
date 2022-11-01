DIMS = {
    "drawable": (480,320),
    "drawable-land-mdpi": (480,320),
    "drawable-land-hdpi": (800,480),
    "drawable-land-xhdpi": (1280,720),
    "drawable-land-xxhdpi": (1600,960),
    "drawable-land-xxxhdpi": (1920,1280),
}
import subprocess
import os

for key,val in DIMS.items():
    size = f'{val[0]}x{val[1]}'
    cmd = f'convert assets/mansion.jpeg -resize {size}^ -gravity Center -extent {size} android/app/src/main/res/{key}/splash.png'
    print(cmd)
    subprocess.call(cmd,shell=True)