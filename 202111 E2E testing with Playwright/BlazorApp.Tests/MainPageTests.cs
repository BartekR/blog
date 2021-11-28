using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using System.Threading.Tasks;
using System;

namespace BlazorApp.Tests;

class MainPageTests : PageTest
{
    private string pageUrl = "";

    [SetUp]
    public void Init()
    {
        pageUrl = "http://localhost:5165";
    }
    
    [Test]
    public async Task PageTitleIsIndex()
    {
        // call to the `/counter` page
        await Page.GotoAsync(this.pageUrl);

        // get page title
        string title = await Page.TitleAsync();

        // assertion for the value
        Assert.AreEqual("Index", title);
    }

    [Test]
    public async Task ClickingCounterRedirectsToCounterPage()
    {
        // call to the main page
        await Page.GotoAsync(this.pageUrl);

        // search for the counter link and click it
        await Page.ClickAsync("text=Counter");

        // verify redirection
        Uri pageUri = new Uri(Page.Url);
        Assert.AreEqual("/counter", pageUri.PathAndQuery);
    }

    [Test]
    public async Task ClickingFetchDataRedirectsToWeatherForecastPage()
    {
        // call to the main page
        await Page.GotoAsync(this.pageUrl);

        // search for the counter link and click it
        await Page.ClickAsync("text=Fetch data");

        // verify redirection
        System.Uri pageUri = new System.Uri(Page.Url);
        Assert.AreEqual("/fetchdata", pageUri.PathAndQuery);
    }
}