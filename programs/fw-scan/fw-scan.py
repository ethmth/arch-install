#!/usr/bin/env python3

import subprocess
import os
import sys
from shutil import which
import opennsfw2 as n2
import pickle

IMAGE_EXT = "png"
INTERVAL=1
PROB_HIGH = 0.7
PROB_LOW = 0.3


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def extract_images(video, output_dir):
    ofile = f"{output_dir}/%04d.{IMAGE_EXT}"
    cmd_args = ["ffmpeg", "-i", video, "-vf", f"fps=1/{INTERVAL}", ofile]

    subprocess.run(cmd_args)


def get_images(output_dir):

    images = []
    for file in os.listdir(output_dir):
        filename, ext = os.path.splitext(file)
        file_path = os.path.join(output_dir, file)

        if ext.lower() != f".{IMAGE_EXT.lower()}":
            continue

        if not os.path.isfile(file_path):
            continue

        try:
            number = int(filename)
        except:
            continue
        images.append((number, file_path))
    
    images.sort()

    images_elapsed = []
    elapsed_seconds = 0
    for number, file_path in images:
        images_elapsed.append((number, file_path, elapsed_seconds))
        elapsed_seconds += INTERVAL
    
    return images_elapsed

    
def get_probs(images):
    if len(images) <= 0:
        return []
    fw_probabilities = n2.predict_images(images)
    return fw_probabilities


def extract_timestamps(files):

    timestamps = []

    start = -1
    high = False
    for file in files:
        file_number, file_path, elapsed_seconds, prob = file
        
        if high == True:
            if prob < PROB_LOW:
                timestamps.append((start, elapsed_seconds))
                high = False
        else:
            if prob > PROB_HIGH:
                high = True
                start = elapsed_seconds
    
    return timestamps


def get_timestamps_single(files):
    timestamps = []

    for file in files:
        file_number, file_path, elapsed_seconds, prob = file
        
        if prob > PROB_HIGH:
            timestamps.append(seconds_to_timestamp(elapsed_seconds))
    
    res = "\n".join(timestamps)

    return res

def seconds_to_timestamp(seconds):
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    seconds = seconds % 60
    return f"{hours:02}:{minutes:02}:{seconds:02}"


def stringify_timestamps(timestamps):
    timestamp_strs = []
    for timestamp in timestamps:
        start, end = timestamp

        start_timestamp = seconds_to_timestamp(start).ljust(10)
        end_timestamp = seconds_to_timestamp(end).ljust(10)

        timestamp_strs.append(f"{start_timestamp} - {end_timestamp}")
    
    result = "\n".join(timestamp_strs)
    return result


def read_data(file):
    with open(file, 'rb') as f:
        files = pickle.load(f)
    return files


def write_data(filepath, files, probs_file = None):
    with open(filepath, 'wb') as f:
        pickle.dump(files, f)
    
    if not probs_file:
        return

    with open(probs_file, 'w') as f:
        for file in files:
            file_number, file_path, elapsed_seconds, prob = file
            line = f"{str(file_number).ljust(8)}\t{prob:.3f}\t{str(elapsed_seconds).ljust(8)}\t{file_path}\n"
            f.write(line)


def scan_video(video):

    if not os.path.isfile(video):
        eprint(video, "is not a file.")
        sys.exit(1)
    
    file_path, ext = os.path.splitext(video)

    if not os.path.exists(file_path):
        os.makedirs(file_path)
        extract_images(video, file_path)
    else:
        eprint(f"WARNING: {file_path} already exists. Not re-extracting images.")


    data_file = f"{file_path}/data.bin"

    if os.path.isfile(data_file):
        eprint(f"WARNING: Using existing data file.")

        files = read_data(data_file)
    else:
        images_elapsed = get_images(file_path)
        images = [image for _,image,_ in images_elapsed]
        probs = get_probs(images)

        files = [images_elapsed[i] + (probs[i],) for i in range(0, len(images_elapsed))]

        write_data(data_file, files, f"{file_path}/probs.txt")


    # timestamps = extract_timestamps(files)
    # output = stringify_timestamps(timestamps)

    output = get_timestamps_single(files)

    with open(f"{file_path}/timestamps.txt", "w") as f:
        f.write(output)
    
    print("Timestamps of interest:")
    print(output)


def main():
    if len(sys.argv) != 2:
        eprint("Usage: fw-scan <video_file>")
        sys.exit(1)
    
    if not which("ffmpeg"):
        eprint("ffmpeg not found on system")
        sys.exit(1)

    video = sys.argv[1]

    scan_video(video)


if __name__ == "__main__":
    main()