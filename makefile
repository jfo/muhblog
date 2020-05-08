deploy: syncs3 push

push: build
	cd ./build && git add -A && git commit -m "`date`" && git push

syncs3:
	aws s3 sync ./static/s3 s3://assets.jfo.click/

syncfroms3:
	aws s3 sync s3://assets.jfo.click/ ./static/s3

# TODO: sort out this damn init
initsubtree:
	git worktree prune
	git checkout --orphan gh-pages
	git worktree add -B gh-pages build publish/gh-pages
	git commit --allow-empty -m "Initializing gh-pages branch"
	git checkout master

build: clean
	NODE_PRODUCTION=true blager

clean:
	rm -r build/*
