from package import *
from helper import Loader


def run_app():
	loader = Loader(id=range(25, 31))
	df = loader.df
    

if __name__ == '__main__':
	run_app()