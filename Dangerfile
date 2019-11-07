# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# ENSURE THAT LABELS HAVE BEEN USED ON THE PR
warn("Please add labels to this PR") if github.pr_labels.empty?

# Swiftlint
swiftlint.lint_files

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title.
if github.pr_body.length < 3 && git.lines_of_code > 10
  warn("Please provide a summary in the Pull Request description")
end

# - Check to see if any of the modified or added files contains a class which isn't indicated as final (final_class)

# Sometimes an added file is also counted as modified. We want the files to be checked only once. 
files_to_check = (git.modified_files + git.added_files).uniq
(files_to_check - %w(Dangerfile)).each do |file|
	next unless File.file?(file)
	# Only check for classes inside swift files
	next unless File.extname(file).include?(".swift")
  	
  	# Will be used to check if we're inside a comment block.
	isCommentBlock = false

	# Will be used to track if we've placed any marks inside our class.
	foundMark = false 

	# Collects all disabled rules for this file.
	disabled_rules = []

	filelines = File.readlines(file)
	filelines.each_with_index do |line, index|
		if isCommentBlock
			if line.include?("*/")
				isCommentBlock = false
			end
		elsif line.include?("/*")
			isCommentBlock = true
		elsif line.include?("danger:disable")
			rule_to_disable = line.split.last
			disabled_rules.push(rule_to_disable)
		else
			# Start our custom line checks
			## Check for the usage of final class
			if disabled_rules.include?("final_class") == false and line.include?("class") and not line.include?("final") and not line.include?("func") and not line.include?("//") and not line.include?("protocol")
				warn("Consider using final for this class or use a struct (final_class)", file: file, line: index+1) 
			end
		end 
	end
end
