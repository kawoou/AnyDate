# Clean
rm -rf _sourcekitten.output.json build/ docs/ _temp/

# Source Kitten
swift build
sourcekitten doc --spm-module AnyDate > _sourcekitten.output.json

# Jazzy
jazzy --clean \
      --sourcekitten-sourcefile _sourcekitten.output.json \
      --output docs/latest \
      --min-acl public \
      --author "Jungwon An" \
      --author_url "http://www.kawoou.kr" \
      --github_url "https://github.com/kawoou/AnyDate" \
      --module AnyDate

# Publish
git clone git@github.com:kawoou/AnyDate.git -b gh-pages _temp
cd _temp
git branch -m gh-pages _gh-pages
git checkout --orphan gh-pages
git reset -- *
rm -rf ./*
cp -r ../docs/latest/* ./
git add ./*
git commit -am "Update Documentation"
git push origin gh-pages -f
cd ..

# Clean
rm -rf _sourcekitten.output.json build/ docs/ _temp/
