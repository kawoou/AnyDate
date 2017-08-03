project:
	swift package generate-xcodeproj
	ruby -e "require 'xcodeproj'; Xcodeproj::Project.open('AnyDate.xcodeproj').save"
