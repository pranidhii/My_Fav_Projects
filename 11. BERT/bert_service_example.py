
# pip install -U bert-serving-server==1.8  # server
# pip install bert-serving-client  # client, independent of `bert-serving-server`
# D:\>cd Downloads
# D:\Downloads>bert-serving-start -model_dir D:\Downloads\uncased_L-12_H-768_A-12 -num_worker=1


from bert_serving.client import BertClient
bc = BertClient(check_version=False)

### Using Bert Remotely
# bc = BertClient(ip='xx.xx.xx.xx')  # ip address of the GPU machine

print(bc.encode(['This is text mining class.', 'then do it right', 'then do it better']))
print(bc.encode(['This is text mining class.', 'then do it right', 'then do it better'])[0])
print(len(bc.encode(['This is text mining class.', 'then do it right', 'then do it better'])[2]))

