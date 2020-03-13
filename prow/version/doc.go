/*
Copyright 2020 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// version holds variables that identify a Prow binary's name and version
package version

var (
	// Name is the colloquial identifier for the compiled component
	Name = "unset"
	// Version is a concatenation of the commit SHA and date for the build
	Version = "0"
)

func UserAgent() string {
	return Name + "/" + Version
}
