touch ~/.vimrc

mv ~/.vimrc ~/.vimrc.bck
cat vimrc > ~/.vimrc

rm -rf ~/.vim
cp -r vim ~/.vim

source clean.sh
