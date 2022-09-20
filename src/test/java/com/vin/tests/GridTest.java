package com.vin.tests;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.safari.SafariDriver;
import org.openqa.selenium.safari.SafariOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;
public class GridTest {

    @Test
    public void RemoteTracingTest() throws MalformedURLException {
        System.setProperty("otel.traces.exporter", "jaeger");
        System.setProperty("otel.exporter.jaeger.endpoint", "http://localhost:14250");
        System.setProperty("otel.resource.attributes", "service.name=selenium-java-client");

        URL gridUrl = new URL("http://localhost:4444");
        FirefoxOptions firefoxOptions = new FirefoxOptions();
        RemoteWebDriver webDriver = new RemoteWebDriver(gridUrl, firefoxOptions);

        webDriver.get("http://www.google.com/ncr");
        webDriver.findElement(By.name("q")).sendKeys("webdriver", Keys.RETURN);

        WebDriverWait webDriverWait = new WebDriverWait(webDriver, Duration.ofSeconds(5));
        webDriverWait.until(ExpectedConditions.titleContains("webdriver"));

        webDriver.quit();
    }

}
