# Video cooker
Merge video, subtitle and watermark using ffmpeg

Run `cooker.ps1` in powershell to merge your video, subtitle and wartermark.

## Important

If you haven't enable script execution on your machine, please start powershell as administration and run the following command:

```
set-executionpolicy remotesigned
```

## Quick start

- Put `ffmpeg.exe` into this folder
- Run `cooker.ps1`
- Choose watermark file
- Choose video foler (currently only support *.mp4 files)
- Choose subtitle foler
- Type in extension for subtitle. For example: ass or csv.ass or other as needed.

The name of subtitle must be <video_file_name>_ass.<extension>. For example, if the video file name is `sample1.mp4`, and the subtitle extension you typed in is `ass`, the subtitle file name should be set to `sample1_ass.ass`.
