# Maintainer: Eric Langlois <eric@langlois.xyz>
pkgname=helloworld
pkgver=1.0.0
pkgrel=1
pkgdesc="Hello World"
url="http://www.example.com"
arch=('any')
license=('MIT')
depends=('python')
source=(helloworld.py LICENSE)
sha256sums=('61b911f2d8b9e9f52e512aa7e273240cbd26bcaf0a5cae4abed5a7a53fdde6e7'
            '943b0a306fec2cbb9368f82d363a1165d26b49dbfef9065c61633a8abeb14027')

check() {
	python helloworld.py
}

package() {
	install -m755 -D "helloworld.py" "$pkgdir/usr/bin/helloworld"
	install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
