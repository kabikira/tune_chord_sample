.PHONY: setup
setup:
	flutter clean
	flutter pub get

flutter_generate:
	flutter clean
	flutter pub get
	# l10nの生成コマンド
	flutter gen-l10n
	# import_sorterの実行コマンド
	flutter pub run import_sorter:main
    # flutter_launcher_iconsの生成コマンド
	flutter pub run flutter_launcher_icons
	# コード生成(build_runner)
	flutter pub run build_runner build --delete-conflicting-outputs

submit_ios:
	flutter clean
	flutter pub get
	#Xcodeを開く
	open ios/Runner.xcworkspace

submit_android:
	flutter clean
	flutter pub get
	#AndroidのBundleを生成する
	flutter build appbundle
