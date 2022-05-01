import pandas as pd


class Loader(object):
	"""docstring for Loader"""
	def __init__(self, directory='./specdata', id=range(1, 333), filter=False):
		super(Loader, self).__init__()
		self.df = self.load(directory, id, filter)
		


	def load(self, directory, id, filter):
		# security checks
		id, _ = self.checkinputs(id)
		
		dfs = []
		for i in id:
			flags = self.flagging(i)
			filepath = f'{directory}/{"0"*flags}{i}.csv'
			df = pd.read_csv(filepath)
			dfs.append(df)

		totaldf = pd.concat(dfs, axis=0, ignore_index=True)
		if filter:
			totaldf.dropna(inplace=True)
		return totaldf



	def flagging(self, i):
		if i < 10: rep = 2
		elif i < 100: rep = 1
		else: rep = 0
		return rep
		
	def checkinputs(self, id, ranges=range(1, 333)):
		try:
			id = int(id)
			assert id in ranges, 'out of ranges'
			id = [id]
		except:
			if isinstance(id, range):
				assert id[0] in ranges and id[-1] in ranges, 'out of range'
			else:
				raise('invalid datatype')
		return id, ranges

