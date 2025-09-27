# App Icon Instructions

## If you don't have an icon ready:

1. **Create a simple icon online:**
   - Go to https://www.canva.com or https://www.figma.com
   - Create 1024x1024 px design
   - Use QRail theme: Blue background with train/QR code icon
   - Export as PNG

2. **Quick option - Use text-based icon:**
   - Blue background (#2196F3)
   - White text "QR" in bold font
   - Add small train icon below

3. **Save the file as:**
   - File name: `icon.png`
   - Location: `E:\Code\SIH\SIH\assets\icon\icon.png`
   - Size: 1024x1024 pixels
   - Format: PNG with transparent background (optional)

## After adding your icon:

Run these commands in terminal:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter clean
flutter build apk
```

Your APK will now have the custom icon!