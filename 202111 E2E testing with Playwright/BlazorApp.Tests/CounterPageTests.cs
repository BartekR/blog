using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using System.Threading.Tasks;
using System;

namespace BlazorApp.Tests;

class CounterPageTests : PageTest
{
    private string pageUrl = "";

    [SetUp]
    public void Init()
    {
        string baseUrl = "http://localhost:5165";
        pageUrl = $"{baseUrl}/counter";
    }
    
    [Test]
    public async Task CounterStartsWithZero()
    {
        // call to the `/counter` page
        await Page.GotoAsync(this.pageUrl);

        // search for the counter value
        var content = await Page.TextContentAsync("p");

        // assertion for the value
        Assert.AreEqual("Current count: 0", content);
    }
}