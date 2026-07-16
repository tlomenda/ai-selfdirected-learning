## ASP.NET Web Application

**Tech Stack**: C# 14, ASP.NET 10 Web API for backend, React and Vite with TypeScript for frontend

**Build Tool**: .NET CLI (`dotnet`) with MSBuild / .sln + .csproj project files

**Testing**: xUnit for unit tests, Moq for mocking, Playwright for E2E tests

**Constraints**: 
- When creating assertions, never use extension libraries like FluentAssertions or the like.
- Never use AutoMapper for object mapping; prefer explicit mapping code.