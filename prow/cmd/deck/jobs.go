/*
Copyright 2016 The Kubernetes Authors.

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

package main

import (
	"fmt"
	"sort"
	"strconv"
	"sync"
	"time"

	"github.com/Sirupsen/logrus"

	"k8s.io/test-infra/prow/kube"
)

const (
	period = 30 * time.Second
)

type Job struct {
	Type        string `json:"type"`
	Repo        string `json:"repo"`
	Refs        string `json:"refs"`
	BaseRef     string `json:"base_ref"`
	BaseSHA     string `json:"base_sha"`
	PullSHA     string `json:"pull_sha"`
	Number      int    `json:"number"`
	Author      string `json:"author"`
	Job         string `json:"job"`
	Context     string `json:"context"`
	Started     string `json:"started"`
	Finished    string `json:"finished"`
	Duration    string `json:"duration"`
	State       string `json:"state"`
	Description string `json:"description"`
	URL         string `json:"url"`
	PodName     string `json:"pod_name"`

	st time.Time
	ft time.Time
}

type JobAgent struct {
	kc   *kube.Client
	jobs []Job
	mut  sync.Mutex
}

func (ja *JobAgent) Start() {
	ja.tryUpdate()
	go func() {
		t := time.Tick(period)
		for range t {
			ja.tryUpdate()
		}
	}()
}

func (ja *JobAgent) Jobs() []Job {
	ja.mut.Lock()
	defer ja.mut.Unlock()
	res := make([]Job, len(ja.jobs))
	copy(res, ja.jobs)
	return res
}

func (ja *JobAgent) tryUpdate() {
	if err := ja.update(); err != nil {
		logrus.WithError(err).Warning("Error updating job list.")
	}
}

type byStartTime []Job

func (a byStartTime) Len() int           { return len(a) }
func (a byStartTime) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a byStartTime) Less(i, j int) bool { return a[i].st.After(a[j].st) }

func (ja *JobAgent) update() error {
	js, err := ja.kc.ListJobs(nil)
	if err != nil {
		return err
	}
	var njs []Job
	for _, j := range js {
		nj := Job{
			Type:        j.Metadata.Labels["type"],
			Repo:        fmt.Sprintf("%s/%s", j.Metadata.Labels["owner"], j.Metadata.Labels["repo"]),
			Refs:        j.Metadata.Annotations["refs"],
			BaseRef:     j.Metadata.Annotations["base-ref"],
			BaseSHA:     j.Metadata.Annotations["base-sha"],
			PullSHA:     j.Metadata.Annotations["pull-sha"],
			Author:      j.Metadata.Annotations["author"],
			Job:         j.Metadata.Labels["jenkins-job-name"],
			Context:     j.Metadata.Annotations["context"],
			Started:     j.Status.StartTime.Format(time.Stamp),
			State:       j.Metadata.Annotations["state"],
			Description: j.Metadata.Annotations["description"],
			URL:         j.Metadata.Annotations["url"],
			PodName:     j.Metadata.Annotations["pod-name"],

			st: j.Status.StartTime,
			ft: j.Status.CompletionTime,
		}
		if !nj.ft.IsZero() {
			nj.Finished = nj.ft.Format("15:04:05")
			nj.Duration = nj.ft.Sub(nj.st).String()
		}
		if pr, err := strconv.Atoi(j.Metadata.Labels["pr"]); err == nil {
			nj.Number = pr
		}
		njs = append(njs, nj)
	}
	sort.Sort(byStartTime(njs))

	ja.mut.Lock()
	defer ja.mut.Unlock()
	ja.jobs = njs
	return nil
}
