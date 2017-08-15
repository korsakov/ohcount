require File.dirname(__FILE__) + '/../../test_helper'

class MavenDependencyTest < Test::Unit::TestCase
  include Ohcount::Gestalt


  def test_dependency
		pom = SourceFile.new("pom.xml", :contents => <<-INLINE
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <dependencies>
    <!-- Compile (global dependencies) -->
    <dependency>
      <groupId>test_group_1</groupId>
      <artifactId>test_artifact_1A</artifactId>
    </dependency>
    <dependency>
      <groupId>test_group_1</groupId>
      <artifactId>test_artifact_1B</artifactId>
    </dependency>
    <dependency>
      <groupId>test_group_2</groupId>
      <artifactId>test_artifact_2A</artifactId>
    </dependency>
    <dependency>
      <groupId>test_group_2</groupId>
      <artifactId>test_artifact_2B</artifactId>
    </dependency>
	</dependencies>
</project>
		INLINE
		)

		r = MavenRule.new('dependency', /1$/, /B$/)

		r.process_source_file(pom)
		assert_equal 1, r.count

  end

  def test_plugin
		pom = SourceFile.new("pom.xml", :contents => <<-INLINE
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <plugins>
    <plugin>
      <groupId>foobar</groupId>
      <artifactId>baz</artifactId>
    </plugin>
	</plugins>
</project>
		INLINE
		)

		r = MavenRule.new('plugin', /^foobar\b/, /^baz\b/)

		r.process_source_file(pom)
		assert_equal 1, r.count
  end
end
