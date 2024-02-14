How to test:

Install dependencies:

```python
pip install azure.identity
pip install azure-storage-blob
```

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

dc = DefaultAzureCredential()
client = BlobServiceClient("https://maxandersonexamplesa.blob.core.windows.net", credential=dc)
blob_client = client.get_blob_client("foo","bar.txt")
data = blob_client.download_blob()
print(data.content_as_text())
```
