import torch
import onnxruntime as ort

model_path = 'models/inswapper_128.onnx'

print("Available proivers:")
print(f'ort avail providers: {ort.get_available_providers()}')


print("Torch outputs:")
print(torch.cuda.current_device())
print(torch.cuda.get_device_name(0))

providers = [
    'CUDAExecutionProvider'
]

session = ort.InferenceSession(model_path, providers=providers)

print("Session Providers:")
print(session.get_providers())