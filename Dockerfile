from base/archlinux
maintainer ditegulov@gmail.com

RUN pacman -Suy --noconfirm
RUN pacman -S sudo grml-zsh-config --noconfirm --needed

RUN useradd -m ctf
RUN echo "ctf ALL=NOPASSWD: ALL" > /etc/sudoers.d/ctf
RUN chsh -s /usr/bin/zsh ctf

# Install pacaur
RUN pacman -S base-devel --noconfirm --needed
RUN pacman -S wget vim --noconfirm --needed

ENV PATH /usr/bin/core_perl/:$PATH

USER ctf
RUN mkdir -p /home/ctf/pacaur_install
WORKDIR /home/ctf/pacaur_install
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
RUN makepkg PKGBUILD --syncdeps --noconfirm --skippgpcheck --install --needed
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
RUN makepkg PKGBUILD --syncdeps --noconfirm --install --needed

WORKDIR /home/ctf
RUN rm -rf /home/ctf/pacaur_install

ENV EDITOR vim

RUN pacaur -S radare2-git --noconfirm --noedit
RUN pacaur -S openssh --noconfirm --noedit
RUN pacaur -S tmux --noconfirm --noedit

RUN echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.gen
RUN sudo locale-gen
ENV LANG en_US.UTF-8

RUN echo -e "eco solarized\ne scr.utf8 = true\ne asm.pseudo = true" > ~/.radare2rc

CMD zsh -i
