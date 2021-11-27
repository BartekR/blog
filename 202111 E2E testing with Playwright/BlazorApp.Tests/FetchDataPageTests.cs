using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using System.Threading.Tasks;
using System;

namespace BlazorApp.Tests;

class FetchDataPageTests : PageTest
{
    [Test]
    public async Task PageTitleIsWeatherForecast()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get page title
        string title = await Page.TitleAsync();

        // assertion for the value
        Assert.AreEqual("Weather forecast", title);
    }

    [Test]
    public async Task TableContains5DataRows_EvalOnSelectorAllAsync_Tr()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        int tableRows = await Page.EvalOnSelectorAllAsync<int>("//table/tbody/tr", "rows => rows.length");

        // assertion for the value
        Assert.AreEqual(5, tableRows);
    }

    [Test]
    public async Task TableContains6RowsTotal()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        int tableRows = await Page.EvalOnSelectorAsync<int>("//table", "tbl => tbl.rows.length");

        // assertion for the value
        Assert.AreEqual(6, tableRows);
    }

    [Test]
    public async Task TableDatesStartTomorrowAscending()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        string date1 = await Page.Locator("//table/tbody/tr[1]/td[1]").InnerTextAsync();
        string date2 = await Page.Locator("//table/tbody/tr[2]/td[1]").InnerTextAsync();
        string date3 = await Page.Locator("//table/tbody/tr[3]/td[1]").InnerTextAsync();
        string date4 = await Page.Locator("//table/tbody/tr[4]/td[1]").InnerTextAsync();
        string date5 = await Page.Locator("//table/tbody/tr[5]/td[1]").InnerTextAsync();

        // assertion for the value
        Assert.AreEqual(DateTime.Now.AddDays(1).ToString("dd.MM.yyyy"), date1);
        Assert.AreEqual(DateTime.Now.AddDays(2).ToString("dd.MM.yyyy"), date2);
        Assert.AreEqual(DateTime.Now.AddDays(3).ToString("dd.MM.yyyy"), date3);
        Assert.AreEqual(DateTime.Now.AddDays(4).ToString("dd.MM.yyyy"), date4);
        Assert.AreEqual(DateTime.Now.AddDays(5).ToString("dd.MM.yyyy"), date5);
    }

    [Test]
    public async Task TableContains5DataRows_EvalOnSelectorAsync_Tr_Rows_Length()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows (no header)
        int tableRows = await Page.EvalOnSelectorAsync<int>("//table/tbody/tr", "rows => rows.length");

        // assertion for the value; returns 0, as one element (EvalOnSelectorAsync returns first found element) has no length property, and Playwright returns 0
        Assert.AreEqual(0, tableRows);
    }

    [Test]
    public async Task TableContains5DataRows_EvalOnSelectorAsync_TBody_ChildNodes_Length()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        int tableRows = await Page.EvalOnSelectorAsync<int>("//table/tbody", "tbody => tbody.childNodes.length");

        // assertion for the value
        Assert.AreEqual(5, tableRows);
    }

    [Test]
    public async Task TableContains5DataRows_EvalOnSelectorAsync_TBody_ChildElementCount()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        int tableRows = await Page.EvalOnSelectorAsync<int>("//table/tbody", "tbody => tbody.childElementCount");

        // assertion for the value
        Assert.AreEqual(5, tableRows);
    }

    [Test]
    public async Task TableContains5DataRows_EvalOnSelectorAsync_Tbody_Rows_Length()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        int tableRows = await Page.EvalOnSelectorAsync<int>("//table/tbody", "tbody => tbody.rows.length");

        // assertion for the value
        Assert.AreEqual(5, tableRows);
    }

    [Test]
    public async Task TableContains5DataRows_Locator()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows using Locator; Locator is strict and requires exactly 1 element to be matched, BUT CountAsync() knows how to handle multiple elements
        int tableRows = await Page.Locator("//table/tbody/tr").CountAsync();

        // assertion for the value
        Assert.AreEqual(5, tableRows);
    }

    [Test]
    public async Task TableHeaderHas16pxFont()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        string fontSize = await Page.EvalOnSelectorAsync<string>("//table/thead/tr/th", "cell => window.getComputedStyle(cell).fontSize");

        // assertion for the value
        Assert.AreEqual("16px", fontSize);
    }

    [Test]
    public async Task TableHeaderHas16pxFont_Locator()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows using Locator(); Locator is strict and requires exactly 1 element to be matched
        string fontSize = await Page.Locator("(//table/thead/tr/th)[1]").EvaluateAsync<string>("cell => window.getComputedStyle(cell).fontSize");

        // assertion for the value
        Assert.AreEqual("16px", fontSize);
    }

    [Test]
    public async Task TableContainsBlackBoldHeader()
    {
        // call to the `/fetchdata` page
        await Page.GotoAsync("http://localhost:5165/fetchdata");

        // get number of table rows
        string fontWeight = await Page.EvalOnSelectorAsync<string>("//table/thead/tr/th", "cell => window.getComputedStyle(cell).fontWeight");

        // assertion for the value
        Assert.AreEqual("700", fontWeight);
    }
}