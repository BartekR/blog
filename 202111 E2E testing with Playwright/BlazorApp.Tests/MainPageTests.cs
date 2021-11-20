using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using System.Threading.Tasks;
using System;

namespace BlazorApp.Tests;

class MainPageTests : PageTest
{
    [Test]
    public async Task CounterStartsWithZero()
    {
        // call to the `/counter` page
        await Page.GotoAsync("http://localhost:5165/counter");

        // search for the counter value
        var content = await Page.TextContentAsync("p");

        // assertion for the value
        Assert.AreEqual("Current count: 0", content);
    }

    [Test]
    public async Task ClickingCounterRedirectsToCounterPage()
    {
        // call to the main page
        await Page.GotoAsync("http://localhost:5165/");

        // search for the counter link and click it
        await Page.ClickAsync("text=Counter");

        // verify redirection
        Uri pageUri = new Uri(Page.Url);
        Assert.AreEqual("/counter", pageUri.PathAndQuery);
    }
}