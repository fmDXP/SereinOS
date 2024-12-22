echo "Distribution Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"


if ! test $(whoami) == "builder" ; then
	echo "Must run as builder!"
	exit -1
fi

echo "Creating build envoirment..."