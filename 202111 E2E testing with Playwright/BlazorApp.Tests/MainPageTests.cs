using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using System.Threading.Tasks;

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
        Assert.AreEqual("Current count: 42", content);
    }
}