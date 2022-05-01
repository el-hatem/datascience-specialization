import pandas as pd

# Task 1
def mean(df, pollutant='both'):
	assert pollutant in ('both', 'sulfate', 'nitrate'), 'invalid option'
	if pollutant == 'nitrate':
		means = df[['nitrate']].mean()	
	elif pollutant == 'sulfate':
		means = df[['sulfate']].mean()
	else:
		means = df[['nitrate', 'sulfate']].mean()
	return means

# Task 2
def complete(df):
	tmp = df.dropna()
	x = tmp.groupby('ID')[['ID']].count()
	x.rename(columns={'ID': 'nobs'}, inplace=True)
	return x


# Task 3
def cor(df, threshold=0):
	comp = complete(df)
	cases = comp.loc[comp['nobs'] >= threshold]
	df = pd.merge(df, cases, left_on='ID', right_on=cases.index)
	df = df[['ID', 'nitrate', 'sulfate']].dropna()
	groups = df.groupby('ID').corr().iloc[::2, 1]
	df = pd.DataFrame(groups.values, columns=['corr'])
	return df
	

	
	

	
	

