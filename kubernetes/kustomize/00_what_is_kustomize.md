# What is kustomize

Kustomize introduces a template-free way to customize application configuration that simplifies the use of off-the-shelf applications.  

Kustomize traverses a Kubernetes manifest to add, remove or update configuration options without forking.

With kustomize you can:
- Have a purely declarative approach to configuration customization
- Have a natively built into kubectl
- Manage an arbitrary number of distinctly customized Kubernetes configurations
- Use it as a standalone binary for extension and integration into other services
- Easily implement it in your CI. Every artifact that kustomize uses is plain YAML and can be validated and processed as such
- Fork/modify/rebase workflow