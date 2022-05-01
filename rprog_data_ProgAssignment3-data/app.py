import pandas as pd
import numpy as np

# global Variables
OUTCOMES = {
	'heart attack': 'heart attack (rate)',
	'heart failure': 'heart failure (rate)',
	'pneumonia': 'pneumonia (rate)'
}


class Loader(object):
	"""docstring for Loader"""
	def __init__(self, filepath='./outcome-of-care-measures.csv'):
		super(Loader, self).__init__()
		self.df = self.load(filepath)

	def load(self, file):
		df = pd.read_csv(file)
		# rename columns' name
		df.rename(columns={
			'Hospital Name': 'hospital',
			'State': 'state',
			'Hospital 30-Day Death (Mortality) Rates from Heart Attack': 'heart attack (rate)',
			'Hospital 30-Day Death (Mortality) Rates from Heart Failure': 'heart failure (rate)',
			'Hospital 30-Day Death (Mortality) Rates from Pneumonia': 'pneumonia (rate)',
		}, inplace=True)
		# select features
		FEATURES = ['state', 'hospital', 'heart attack (rate)', 'heart failure (rate)', 'pneumonia (rate)']
		df = df[FEATURES]
		# set state to be index
		df.set_index('state', inplace=True)

		#return useful dataframe
		return df


	def rank(self, state='all', outcome='heart attack', rank='best'):
		# helper method to get ranked hospital for each state
		def getgroup(g):
			g.replace('Not Available', np.nan, inplace=True)
			g.dropna(inplace=True)
			g[OUTCOMES[outcome]] = pd.to_numeric(g[OUTCOMES[outcome]]).round(1)

			g = g.sort_values(by=[OUTCOMES[outcome], 'hospital']).hospital
			if rank == 'best':
				return g.iloc[0]
			elif rank == 'worst':
				return g.iloc[-1]
			return  None if len(g) < rank else g.iloc[rank - 1]


		# security checks
		state = state.upper()
		outcome = outcome.lower()
		# assert that outcome is already valid
		assert outcome in OUTCOMES.keys(), 'invalid outcome'
		# assert that given state in list of states available
		assert (state.upper() in self.df.index.unique() or state.upper() == 'ALL'), 'invalid state'
		# assert that it is available rank option
		assert (isinstance(rank, int) or rank.lower() in ('best', 'worst')), 'invalid rank option'
		if state == 'ALL':
			selected_df = self.df[['hospital', OUTCOMES[outcome]]]
			return selected_df.groupby(selected_df.index).apply(
				lambda group: getgroup(group)
			)
		else:
			selected_df = self.df.loc[self.df.index==state][['hospital', OUTCOMES[outcome]]]
			return getgroup(selected_df)
		
# main script
loader = Loader()
rank = loader.rank('all', "heart attack", 20).head(10)
print(rank)
		