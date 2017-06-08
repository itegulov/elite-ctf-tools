from base/archlinux
maintainer ditegulov@gmail.com

RUN pacman -Suy
RUN pacman -S sudo grep gettext zsh --noconfirm --needed

RUN useradd -m ctf
RUN echo "ctf ALL=NOPASSWD: ALL" > /etc/sudoers.d/ctf
RUN chsh -s /usr/bin/zsh ctf

# Install pacaur
RUN pacman -S binutils pkg-config make gcc fakeroot --noconfirm --needed
RUN pacman -S expac perl yajl git --noconfirm --needed
RUN pacman -S wget awk patch vim --noconfirm --needed

ENV PATH /usr/bin/core_perl/:$PATH

USER ctf
RUN mkdir -p /home/ctf/pacaur_install
WORKDIR /home/ctf/pacaur_install
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
RUN makepkg PKGBUILD --noconfirm --skippgpcheck --install --needed
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
RUN makepkg PKGBUILD --noconfirm --install --needed

WORKDIR /home/ctf
RUN rm -rf /home/ctf/pacaur_install

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

ENV EDITOR vim

RUN pacaur -S radare2-git --noconfirm --noedit
RUN pacaur -S openssh --noconfirm --noedit

CMD zsh -i
