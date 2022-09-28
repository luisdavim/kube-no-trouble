package collector

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	CollectorAnnotation = "doit-intl.com/kube-no-trouble"
)

type MetaOject struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
}

type Collector interface {
	Get() ([]MetaOject, error)
	Name() string
}

type VersionCollector interface {
	GetServerVersion() (*Version, error)
}

type commonCollector struct {
	name string
}

func newCommonCollector(name string) *commonCollector {
	return &commonCollector{
		name: name,
	}
}

func (c *commonCollector) Name() string {
	return c.name
}

func setCollectorAnnotation(manifest *MetaOject, collectorName string) {
	if manifest.Annotations == nil {
		manifest.Annotations = make(map[string]string)
	}
	manifest.Annotations[CollectorAnnotation] = collectorName
}
