import numpy as np
from bert_serving.client import BertClient
bc = BertClient(check_version=False)

class SimilarModel:
    def __init__(self):
        self.bert_client = BertClient(check_version=False)

    def close_bert(self):
        self.bert_client.close()

    def get_sentence_vec(self,sentence):
        '''
        Obtain vectors based on bert
        :param sentence:
        :return:
        '''
        return self.bert_client.encode([sentence])[0]

    def cos_similar(self,sen_a_vec, sen_b_vec):
        '''
        Cosine similarity
        :param sen_a_vec:
        :param sen_b_vec:
        :return:
        '''
        vector_a = np.mat(sen_a_vec)
        vector_b = np.mat(sen_b_vec)
        num = float(vector_a * vector_b.T)
        denom = np.linalg.norm(vector_a) * np.linalg.norm(vector_b)
        cos = num / denom
        return cos

if __name__=='__main__':
    # Find the most similar one to sentence_a from condinates
    condinates = ['Text mining is useful','Computer vision is useful','Five text analytics approaches','I love text mining']
    sentence_a = 'Text analytics is useful'
    bert_client = SimilarModel()
    max_cos_similar = 0
    most_similar_sentence = ''
    for sentence_b in condinates:
        sentence_a_vec = bert_client .get_sentence_vec(sentence_a)
        sentence_b_vec = bert_client .get_sentence_vec(sentence_b)
        cos_similar = bert_client .cos_similar(sentence_a_vec,sentence_b_vec)
        if cos_similar > max_cos_similar:
            max_cos_similar = cos_similar
            most_similar_sentence = sentence_b

    print('The most similar sentence：',most_similar_sentence)
    bert_client .close_bert()
    # The most similar sentence： Text mining is useful