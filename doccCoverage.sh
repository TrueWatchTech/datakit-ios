#!/bin/sh
if [ -z "${BASH_VERSION:-}" ]; then
exec /bin/bash "$0" "$@"
fi

case ":${SHELLOPTS:-}:" in
*:posix:*)
exec /bin/bash "$0" "$@"
;;
esac

set -euo pipefail

# sh doccCoverage.sh all    Get documentation coverage for all files
# sh doccCoverage.sh        Get documentation coverage for public files
# bash doccCoverage.sh all  Get documentation coverage for all files
# bash doccCoverage.sh      Get documentation coverage for public files
project='FTSDK.xcodeproj'
project_path="${project}/project.pbxproj"
scheme='FTSDK'
configuration="${CONFIGURATION:-Release}"
sdk="${SDK:-iphoneos}"
derived_data_path="${DERIVED_DATA_PATH:-build/DocCCoverageDerivedData}"
project_backup=''
docc_temp_root=''

cleanup(){
if [[ -n "$project_backup" && -f "$project_backup" ]]; then
cp "$project_backup" "$project_path"
rm -f "$project_backup"
fi
if [[ -n "$docc_temp_root" && -d "$docc_temp_root" ]]; then
rm -rf "$docc_temp_root"
fi
}
trap cleanup EXIT

changeFileAttributeToPublic(){
project_backup=$(mktemp "${TMPDIR:-/tmp}/FTSDKProject.XXXXXX.pbxproj")
cp "$project_path" "$project_backup"
perl -0pi -e 's/^(\s*[A-F0-9]+ \/\* [^\n]*\.h in Headers \*\/ = \{isa = PBXBuildFile; fileRef = [^;]+;)(?: settings = \{ATTRIBUTES = \([^)]*\); \};)? \};$/$1 settings = {ATTRIBUTES = (Public, ); }; };/mg' "$project_path"
}

createTempDocCCatalog(){
docc_temp_root=$(mktemp -d "${TMPDIR:-/tmp}/FTSDKDocs.XXXXXX")
local docc_catalog="${docc_temp_root}/${scheme}.docc"
mkdir -p "$docc_catalog"
printf '# %s\n\nAPI documentation coverage.\n' "$scheme" > "${docc_catalog}/${scheme}.md"
echo "$docc_catalog"
}

findSymbolGraphDir(){
local search_root="${derived_data_path}/Build/Intermediates.noindex"
local found=''
while IFS= read -r candidate; do
found="$candidate"
break
done < <(find "$search_root" -type d -path "*/${scheme}.build/symbol-graph" 2>/dev/null)

if [[ -z "$found" ]]; then
echo "error: symbol graph directory not found under ${search_root}" >&2
exit 1
fi

echo "$found"
}

doccCoverage(){
echo '----- Cleaning in progress -----'
xcodebuild -project "$project" \
           -scheme "$scheme" \
           -configuration "$configuration" \
           -sdk "$sdk" \
           -derivedDataPath "$derived_data_path" \
           clean -quiet
echo 'Cleaning completed -->>> build'
xcodebuild -project "$project" \
           -scheme "$scheme" \
           -configuration "$configuration" \
           -sdk "$sdk" \
           -derivedDataPath "$derived_data_path" \
           DOCC_EXTRACT_SWIFT_INFO_FOR_OBJC_SYMBOLS=NO \
           -quiet
echo 'build completion -->>> docc'
local docc_catalog
local symbol_graph_dir
docc_catalog=$(createTempDocCCatalog)
symbol_graph_dir=$(findSymbolGraphDir)
xcrun docc convert "$docc_catalog" \
--fallback-display-name "$scheme" \
--fallback-bundle-identifier com.ft.sdk.FTSDK \
--fallback-bundle-version 1.0 \
--additional-symbol-graph-dir "$symbol_graph_dir" \
--experimental-documentation-coverage \
--coverage-summary-level detailed
}

# If "all", get documentation coverage for all files
FT_ALL_FILE_COVERAGE="${1:-}"
echo "----- Start -----"

if [[ "$FT_ALL_FILE_COVERAGE" == "all" ]]; then
echo "-----changeFileAttributeToPublic Start-----"
changeFileAttributeToPublic
echo "-----changeFileAttributeToPublic End-----"
fi

echo "-----Coverage Start-----"
doccCoverage
echo "-----Coverage End-----"
echo "----- End -----"
