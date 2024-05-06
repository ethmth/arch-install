import torch

device_count = torch.cuda.device_count()

for i in range(device_count):
   print(torch.cuda.get_device_properties(i).name)

if device_count == 0:
    print("No devices found.")