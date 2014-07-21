<?php

/*

project dir = examples/project id
dir_base = examples
tmp_base = examples/tmp
uniq = random unique id
build_dir = tmp_base/unique id

mkdir -p build_dir
cp -R project dir/* build_dir
cd build_dir
make
cat applet/project id.hex

*/

error_reporting(E_ALL);

if(isset($argv[1]))
	$project_id = $argv[1];
else
	$project_id = $_GET['id'];
$project_dir = "/home/testing/examples/" . $project_id . "/";

if(!is_dir($project_dir))
	die("uh, no project");

$unique_id = uniqid("build-", true);
$build_dir = "/home/testing/build/$unique_id/";
`mkdir -p '$build_dir'; cp -R '$project_dir' '$build_dir'`;
`cd '$build_dir$project_id'; make;`;
$hex = file_get_contents($build_dir . "$project_id/applet/$project_id.hex");
`rm -Rf '$build_dir'`;

header("Content-Type: text/plain");
echo "unique compiler ID: $unique_id, used codebase # $project_id\n\n";
echo $hex;


