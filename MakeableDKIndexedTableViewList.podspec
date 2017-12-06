#
#  Be sure to run `pod spec lint MakeableDKIndexedTableViewList.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "MakeableDKIndexedTableViewList"
s.summary = "A framework for indexing a list/array of elements for a sectioned tableview."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE.txt" }

# 4
s.author = { "Andreas Dybdahl" => "andreas@makeable.dk" }

# 5
s.homepage = "https://github.com/makeabledk/swift-indexedtableviewlist-framework"

# 6
s.source = { :git => "https://github.com/makeabledk/swift-indexedtableviewlist-framework.git", :tag => "#{s.version}" }

# 7


# 8
s.source_files  = "MakeableDKIndexedTableViewList", "MakeableDKIndexedTableViewList/**/*.{h,m,swift}"

# 9

end
