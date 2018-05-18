default:
	cat vimrc > ~/.vimrc
	-rm -rf ~/.vim
	cp -r vim ~/.vim

clean:
	rm -rf `pwd`
